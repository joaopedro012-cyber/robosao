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
  late SerialPort porta;

  @override
  void initState() {
    super.initState();
    porta = SerialPort("COM4");
  }

  @override
  void dispose() {
    finalizacaoSerialPort(porta);
    super.dispose();
  }

  Widget _buildAutomacaoCampo(String objetoAutomacao, double width) {
    return Container(
      width: width,
      alignment: Alignment.topLeft,
      child: AutomacaoCampo(
        objetoAutomacao: objetoAutomacao,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth * 0.35;

    return SingleChildScrollView(
      child: Wrap(
        verticalDirection: VerticalDirection.down,
        children: [
          _buildAutomacaoCampo('Sensores', itemWidth),
          _buildAutomacaoCampo('Motores Horizontal', itemWidth),
          _buildAutomacaoCampo('Motores Vertical', itemWidth),
          _buildAutomacaoCampo('Plataforma', itemWidth),
          _buildAutomacaoCampo('Botões Plataforma', itemWidth),
          _buildAutomacaoCampo('Botão Roda Dianteira', itemWidth),
          SizedBox(
            width: screenWidth,
            height: screenWidth * 0.15,
            child: Column(
              children: [
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
