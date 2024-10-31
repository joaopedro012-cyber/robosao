import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
import 'package:libserialport/libserialport.dart';

class AutomacaoCampo extends StatefulWidget {
  final String objetoAutomacao;
  const AutomacaoCampo({super.key, required this.objetoAutomacao});

  @override
  State<AutomacaoCampo> createState() => _AutomacaoCampoState();
}

class _AutomacaoCampoState extends State<AutomacaoCampo> {
  fui.AutoSuggestBoxItem<String>? selected;
  String porta = 'Porta não encontrada';
  List<fui.AutoSuggestBoxItem<String>> objetoListaDePortas = [];
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    _carregaPortasDisponiveis();
    carregaInfo();
  }

  void _carregaPortasDisponiveis() {
    objetoListaDePortas = SerialPort.availablePorts
        .map((port) => fui.AutoSuggestBoxItem<String>(value: port, label: port))
        .toList();
  }

  Future<void> carregaInfo() async {
    String? portaCarregada = await carregaInfoJson('automacao', widget.objetoAutomacao, 'porta');
    setState(() {
      porta = portaCarregada ?? 'Porta não encontrada';
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.objetoAutomacao),
              SizedBox(
                width: screenWidth * 0.30,
                child: fui.AutoSuggestBox<String>(
                  placeholder: porta,
                  items: objetoListaDePortas,
                  onSelected: (item) async {
                    setState(() => selected = item);
                    await atualizaJson('automacao', widget.objetoAutomacao, 'porta', item.value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
