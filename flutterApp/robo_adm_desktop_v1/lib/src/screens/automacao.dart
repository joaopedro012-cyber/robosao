import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';
import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/widgets/monitor_serial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    SerialPort porta = SerialPort("COM4");
    return Wrap(
        verticalDirection: VerticalDirection.down,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Sensores',
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Motores Horizontal',
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Motores Vertical',
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Plataforma',
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Botões Plataforma',
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            alignment: Alignment.topLeft,
            child: const AutomacaoCampo(
              objetoAutomacao: 'Botão Roda Dianteira',
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: screenWidth * 0.15,
            child: Wrap(children: <Widget>[
              const AutomacaoCampo(
                objetoAutomacao: 'Monitor Serial Padrao',
              ),
              FilledButton(
                child: const Text('FECHA A CONEXÃO'),
                onPressed: () => finalizacaoSerialPort(porta),
              ),
              Container(
                  color: Colors.black,
                  width: screenWidth,
                  child: MonitorSerial(
                    portaConexao: porta,
                  ))
            ]),
          ),
        ]);
  }
}
