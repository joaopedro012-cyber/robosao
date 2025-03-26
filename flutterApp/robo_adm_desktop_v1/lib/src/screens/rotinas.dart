import 'dart:convert';
import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class RotinasPage extends StatefulWidget {
  final bool conexaoAtiva;
  final Function onPause;
  final Function onResume;

  const RotinasPage({
    super.key,
    required this.conexaoAtiva,
    required this.onPause,
    required this.onResume,
  });

  @override
  RotinasPageState createState() => RotinasPageState();
}

class RotinasPageState extends State<RotinasPage> {
  List<PlatformFile>? _paths;
  bool isPaused = false;
  String? _rotinaTexto; // Armazena o conteúdo do JSON selecionado
  Map<String, dynamic>? _rotina; // Armazena a rotina em formato de mapa

  void _logException(String message) {
    print(message);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _selecionaArquivos() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['json'],
        dialogTitle: "Selecione o Arquivo de Rotina",
        initialDirectory: "C:\\",
        lockParentWindow: false,
      ))?.files;

      if (_paths != null && _paths!.isNotEmpty) {
        final file = File(_paths!.first.path!);
        final content = await file.readAsString();
        final rotina = jsonDecode(content);

        setState(() {
          _rotinaTexto = jsonEncode(rotina); // Atualiza o estado para exibir no Expander
          _rotina = rotina; // Armazena a rotina para execução posterior
        });

        print("Rotina carregada: $_rotinaTexto");
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }

  // Função para executar a rotina
  void _executarRotina() {
    if (_rotina != null && widget.conexaoAtiva && !isPaused) {
      if (_rotina!['acoes'] != null && _rotina!['acoes'] is List) {
        for (var acao in _rotina!['acoes']) {
          if (isPaused) break;

          final comando = acao['comando'];
          final duracao = acao['duracao'];

          print("Executando comando: $comando por $duracao ms");

          Future.delayed(Duration(milliseconds: duracao), () {
            if (!isPaused) {
              print("Comando $comando concluído");
            }
          });
        }
      } else {
        print("Formato de rotina inválido. 'acoes' não encontrado.");
      }
    } else {
      _logException('Conexão não estabelecida ou rotina pausada.');
    }
  }

  // Função para pausar a rotina
  void pauseRoutine() {
    setState(() {
      isPaused = true;
    });
    widget.onPause();
  }

  // Função para retomar a rotina
  void resumeRoutine() {
    setState(() {
      isPaused = false;
    });
    widget.onResume();
  }

  void _resetState() {
    setState(() {
      _paths = null;
      _rotinaTexto = null;
      _rotina = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciamento de Rotinas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.27,
                  child: fui.TextBox(
                    readOnly: true,
                    placeholder: _rotinaTexto != null
                        ? 'Rotina Selecionada'
                        : 'Selecione a Rotina.json',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.08,
                  child: FilledButton(
                    onPressed: _selecionaArquivos,
                    child: const Text('Selecionar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.35,
              child: fui.Expander(
                header: const Text('Rotina Selecionada'),
                content: SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Text(
                      _rotinaTexto ?? 'Nenhuma rotina carregada.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botão para executar a rotina
            FilledButton(
              onPressed: _executarRotina,
              child: const Text('Iniciar Execução'),
            ),
          ],
        ),
      ),
    );
  }
}
