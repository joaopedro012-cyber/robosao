import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
import 'package:flutter/foundation.dart';
import 'package:libserialport/libserialport.dart';
import 'package:flutter/material.dart';

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  late List<String> portasDisponiveis;
  dynamic conexao1Porta;

  @override
  void initState() {
    super.initState();
    portasDisponiveis = SerialPort.availablePorts;
    carregaInfoJson('automacao', 'Sensores', 'porta').then((value) {
      setState(() {
        conexao1Porta = value as String?;
      });
      if (kDebugMode) {
        print(conexao1Porta);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Portas sendo utilizadas: $portasDisponiveis');
    }

    return const AutomacaoCampo(
      objetoAutomacao: 'Sensores',
      // campo: 'Sensores',
      // placeholder: conexao1Porta ?? 'vazio',
      // portasArduino: portasDisponiveis,
      // onPortasChanged: (String novaPorta) {
      //   atualizaJson('automacao', 'Sensores', 'porta', '123456');
      // },
    );
  }
}
