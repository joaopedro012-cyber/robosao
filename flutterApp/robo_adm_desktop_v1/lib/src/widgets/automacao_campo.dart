import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
import 'package:libserialport/libserialport.dart';

late List<fui.AutoSuggestBoxItem<String>> objetoListaDePortas;

class AutomacaoCampo extends StatefulWidget {
  final String objetoAutomacao;
  const AutomacaoCampo({super.key, required this.objetoAutomacao});

  @override
  State<AutomacaoCampo> createState() => _AutomacaoCampoState();
}

class _AutomacaoCampoState extends State<AutomacaoCampo> {
  fui.AutoSuggestBoxItem<String>? selected;
  String porta = '';
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    objetoListaDePortas = SerialPort.availablePorts
        .map((port) => fui.AutoSuggestBoxItem(value: port, label: port))
        .toList();

    carregaInfo();
  }

  Future<void> carregaInfo() async {
    porta = await carregaInfoJson('automacao', 'Sensores', 'porta');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        spacing: screenWidth * 0.05,
        runSpacing: screenWidth * 0.02,
        children: [
          SizedBox(
            width: screenWidth * 0.35,
            child: Row(
              children: [
                Text(widget.objetoAutomacao),
                SizedBox(
                  width: screenWidth * 0.30,
                  child: fui.AutoSuggestBox<String>(
                      placeholder: porta,
                      items: objetoListaDePortas,
                      onSelected: (item) async {
                        setState(() => selected = item);
                        await atualizaJson('automacao', widget.objetoAutomacao,
                            'porta', item.value);
                      }),
                )
              ],
            ),
          )
        ]);
  }
}
