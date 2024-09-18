import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_picker/file_picker.dart';


class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  bool filledDisabled = false;
  @override
  Widget build(BuildContext context) {
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
                child: const TextBox(
                
                readOnly: true,
                placeholder: 'Selecione a Rotina.json',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 14.0,
                  color: Color(0xFF5178BE),
                ),
              ),),
            SizedBox( 
              width: screenWidth * 0.08,
              child:
              FilledButton(
                onPressed: filledDisabled ? null : () => debugPrint('Selecionado'),
                child: const Text('Selecionar'),
              ),),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.35,
          child: const Expander(
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
