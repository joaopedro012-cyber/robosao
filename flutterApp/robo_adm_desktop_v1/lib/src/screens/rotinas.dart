// rotinas_page.dart
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
  Map<String, dynamic>? _rotina;

  void _selecionaArquivos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      final file = File(result.files.first.path!);
      final jsonContent = jsonDecode(await file.readAsString());

      setState(() {
        _rotina = jsonContent;
      });

      print("Rotina carregada: $_rotina");
    }
  }

  void _executarRotina(ConexaoProvider conexaoProvider) async {
    if (_rotina == null || _rotina!['acoes'] == null) {
      print("Rotina inválida ou não carregada.");
      return;
    }

    final porta = conexaoProvider.obterPortaSelecionada('identificador_necessario');
    if (porta == null || !SerialPort.availablePorts.contains(porta)) {
      print("Porta serial não encontrada ou não conectada.");
      return;
    }

    final serialPort = SerialPort(porta);
    if (!serialPort.openReadWrite()) {
      print("Erro ao abrir porta $porta.");
      return;
    }

    widget.onPause();

    for (var acao in _rotina!['acoes']) {
      final comando = acao['comando'];
      final duracao = acao['duracao'];

      print("Comando: $comando | Duração: $duracao ms");
      serialPort.write(utf8.encode('$comando\n'));
      await Future.delayed(Duration(milliseconds: duracao));
    }

    serialPort.close();
    widget.onResume();
    print("Rotina finalizada com sucesso!");
  }

  @override
  Widget build(BuildContext context) {
    final conexaoProvider = Provider.of<ConexaoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciamento de Rotinas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: fluent.TextBox(
                    readOnly: true,
                    placeholder: _rotina != null
                        ? 'Rotina carregada'
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
                header: const Text('Conteúdo da Rotina'),
                content: Text(jsonEncode(_rotina), style: const TextStyle(fontSize: 12)),
              ),
            const SizedBox(height: 20),
            fluent.FilledButton(
              onPressed: conexaoProvider.obterPortaSelecionada('identificador_necessario') != null
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
