import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});
  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  bool filledDisabled = false;
  @override
  Widget build(BuildContext context) {
    void logException(String message) {
      if (kDebugMode) {
        print(message);
      }

      GlobalKey<ScaffoldMessengerState>().currentState?.hideCurrentSnackBar();
      GlobalKey<ScaffoldMessengerState>().currentState?.showSnackBar(
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

    void selecionaArquivos() async {
      try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        Directory diretoriosArquivo = await getApplicationDocumentsDirectory();
        String diretorioFinalCaminho = '${diretoriosArquivo.path}/Rotinas Robo';
        
        Directory diretorioFinal = Directory(diretorioFinalCaminho);
        if(!await diretorioFinal.exists()) {
          await diretorioFinal.create(recursive: true);
        }

        for (PlatformFile file in result.files) {
          if (file.extension == 'json') {
            File sourceFile = File(file.path!);
            String diretorioFinalArquivo = '$diretorioFinalCaminho/${file.name}';
            await sourceFile.copy(diretorioFinalArquivo);
          } else {
            logException('Arquivo ${file.name} não é um .json e foi ignorado.');
          }
        }
        logException('Arquivos copiados com sucesso!');
      }
    } on PlatformException catch (e) {
      logException('Unsupported operation: $e');
    }catch (e) {
      logException(e.toString());
    }
    }
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: screenWidth * 0.35,
          child: Wrap(
            children: [
              SizedBox(
                width: screenWidth * 0.27,
                child: const fui.TextBox(
                  readOnly: true,
                  placeholder: 'Selecione a Rotina.json',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14.0,
                    color: Color(0xFF5178BE),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.08,
                child: FilledButton(
                  onPressed: () => selecionaArquivos(),
                  child: const Text('Selecionar'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.35,
          child: const fui.Expander(
              header: Text('Open to see'),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Text('A long Text He'),
                ),
              )),
        ),
      ],
    );
  }
}
