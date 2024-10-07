import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/utils/funcoes_config_json.dart';
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
    //double screenWidth = MediaQuery.of(context).size.width;
    late List<String> portasDisponiveis = SerialPort.availablePorts;
    String conexao1Porta = 'teste2';

    if (kDebugMode) {
      print('Portas sendo utilizadas: $portasDisponiveis');
    }

    // List<fui.AutoSuggestBoxItem<String>> portasItens = portasDisponiveis
    //     .map((porta) => fui.AutoSuggestBoxItem<String>(
    //           value: porta,
    //           label: porta,
    //         ))
    //     .toList();

    return AutomacaoCampo(
        campo: 'Sensores',
        placeholder: conexao1Porta,
        portasArduino: portasDisponiveis,
        onPortasChanged: (String novaPorta) {
          atualizarConfigJsonAutomacao('Sensores', conexao1Porta);
        });

    // return Wrap(
    //   children: [
    //     SizedBox(
    //       width: screenWidth * 0.25,
    //       child: const Text('Sensores'),
    //     ),
    //     SizedBox(
    //       width: screenWidth * 0.45,
    //       child: fui.AutoSuggestBox<String>(
    //         placeholder: 'Selecione uma porta.',
    //         items: portasItens,
    //         onSelected: (item) {
    //           setState(() {
    //             conexao1Porta = item.value;
    //             if (kDebugMode) {
    //               print('porta selecionada: $conexao1Porta');
    //             }
    //           });
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
