import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/widgets/monitor_serial.dart';
import 'package:flutter/material.dart';

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 1,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Sensores',
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: screenWidth * 0.15,
            child: Wrap(children: <Widget>[
              const AutomacaoCampo(
                objetoAutomacao: 'Monitor Serial Padrao',
              ),
              Container(
                color: Colors.black,
                width: screenWidth,
                child: const MonitorSerial(portaConexao: 'COM4'),
              )
            ]),
          ),
        ]);
  }
}
