import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class RotinasPage extends StatefulWidget {
  final bool conexaoAtiva; // Receberá o estado da conexão
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
  bool isPaused = false; // Controle para verificar se a rotina está pausada

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

  // Função para selecionar e carregar arquivos
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

        print("Rotina carregada: $rotina");

        // Iniciar a execução da rotina se a conexão estiver ativa
        if (widget.conexaoAtiva && !isPaused) {
          _executarRotina(rotina);
        } else {
          _logException('Conexão não estabelecida ou rotina pausada.');
        }
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
  }

  // Função para executar a rotina
  void _executarRotina(Map<String, dynamic> rotina) {
    if (rotina['acoes'] != null && rotina['acoes'] is List) {
      for (var acao in rotina['acoes']) {
        if (isPaused) break; // Pausar a execução quando necessário

        final comando = acao['comando'];
        final duracao = acao['duracao'];

        print("Executando comando: $comando por $duracao ms");

        // Simula o envio do comando ao robô
        // Substitua pelo código real de envio, por exemplo: bluetooth.send(comando);
        Future.delayed(Duration(milliseconds: duracao), () {
          if (!isPaused) {
            print("Comando $comando concluído");
          }
        });
      }
    } else {
      print("Formato de rotina inválido. 'acoes' não encontrado.");
    }
  }

  // Função para pausar a rotina
  void pauseRoutine() {
    setState(() {
      isPaused = true;
    });
    widget.onPause(); // Notificar a pausa para o `SensoresPage`
  }

  // Função para retomar a rotina
  void resumeRoutine() {
    setState(() {
      isPaused = false;
    });
    widget.onResume(); // Notificar para retomar a rotina
  }

  void _resetState() {
    setState(() {
      _paths = null;
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
                  child: const fui.TextBox(
                    readOnly: true,
                    placeholder: 'Selecione a Rotina.json',
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
              child: const fui.Expander(
                header: Text('Selecione a Rotina'),
                content: SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Text('Texto longo aqui'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
