import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:libserialport/libserialport.dart';
import 'package:flutter/material.dart';

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    List<String> portasDisponiveis = SerialPort.availablePorts;
    String? conexao1Porta;

    if (kDebugMode) {
      print('Portas sendo utilizadas: $portasDisponiveis');
    }

    List<fui.AutoSuggestBoxItem<String>> portasItens = portasDisponiveis
        .map((porta) => fui.AutoSuggestBoxItem<String>(
              value: porta,
              label: porta,
            ))
        .toList();

    return Column(
      children: [
        fui.AutoSuggestBox<String>(
          placeholder: 'Selecione uma porta.',
          items: portasItens,
          onSelected: (item) {
            setState(() {
              conexao1Porta = item.value;
              if (kDebugMode) {
                print('porta selecionada: $conexao1Porta');
              }
            });
          },
        ),
      ],
    );
  }
}
