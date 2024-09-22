import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
      try {
      await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.custom,
        allowMultiple: true,
        //onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['json'],
        dialogTitle: "_dialogTitleController",
        initialDirectory: "C:\\",
        lockParentWindow: false,
      )
          ;
    } on PlatformException catch (e) {
      logException('Unsupported operation$e');
    } catch (e) {
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
