import 'dart:convert';
import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:robo_adm_desktop_v1/src/providers/conexao_provider.dart';

class RotinasPage extends StatefulWidget {
  final bool conexaoAtiva;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const RotinasPage({
    super.key,
    required this.conexaoAtiva,
    required this.onPause,
    required this.onResume,
  });

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<PlatformFile>? _paths;
  Map<String, dynamic>? _rotina;
  bool isExecuting = false;

  void _selecionaArquivos() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      ))?.files;

      if (_paths != null && _paths!.isNotEmpty) {
        final file = File(_paths!.first.path!);
        final content = await file.readAsString();
        final rotina = jsonDecode(content);

        setState(() {
          _rotina = rotina;
        });

        print("Rotina carregada: $_rotina");
      }
    } catch (e) {
      print('Erro ao selecionar arquivo: ${e.toString()}');
    }
  }

  void _executarRotina(ConexaoProvider conexaoProvider) async {
    if (_rotina == null) {
      print("Nenhuma rotina carregada.");
      return;
    }

    // Supondo que o método requer um identificador de dispositivo ou similar
    String? portaSelecionada = conexaoProvider.obterPortaSelecionada('identificador_necessario');
    if (portaSelecionada == null) {
      print("Erro: Nenhuma porta COM foi selecionada!");
      return;
    }

    final port = SerialPort(portaSelecionada);
    if (!port.openReadWrite()) {
      print("Erro: Não foi possível abrir a porta $portaSelecionada");
      return;
    }

    setState(() {
      isExecuting = true;
    });

    widget.onPause();

    for (var acao in _rotina!['acoes']) {
      String comando = acao['comando'];
      int duracao = acao['duracao'];

      print("Enviando comando: $comando por $duracao ms");

      port.write(utf8.encode('$comando\n'));
      await Future.delayed(Duration(milliseconds: duracao));
    }

    port.close();

    setState(() {
      isExecuting = false;
    });

    widget.onResume();

    print("Rotina finalizada!");
  }

  @override
  Widget build(BuildContext context) {
    final conexaoProvider = Provider.of<ConexaoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciamento de Rotinas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: fluent.TextBox(
                    readOnly: true,
                    placeholder: _rotina != null
                        ? 'Rotina Selecionada'
                        : 'Selecione um arquivo JSON',
                  ),
                ),
                const SizedBox(width: 10),
                fluent.FilledButton(
                  onPressed: _selecionaArquivos,
                  child: const Text('Selecionar Rotina'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_rotina != null)
              fluent.Expander(
                header: const Text('Rotina Selecionada'),
                content: Text(jsonEncode(_rotina), style: const TextStyle(fontSize: 14)),
              ),
            const SizedBox(height: 20),
            fluent.FilledButton(
              onPressed: (_rotina != null && conexaoProvider.obterPortaSelecionada('identificador_necessario') != null)
                  ? () => _executarRotina(conexaoProvider)
                  : null,
              child: const Text('Iniciar Execução'),
            ),
          ],
        ),
      ),
    );
  }
}
