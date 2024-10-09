import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/utils/funcoes_config_json.dart';
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
  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    late List<String> portasDisponiveis = SerialPort.availablePorts;
    dynamic conexao1Porta;

    void atualizaConexao1Porta() async {
      conexao1Porta = await carregaInfoJson('automacao', 'Sensores', 'porta');
    }

    if (kDebugMode) {
      print('Portas sendo utilizadas: $portasDisponiveis');
    }

    return AutomacaoCampo(
        campo: 'Sensores',
        placeholder: conexao1Porta ?? 'vazio',
        portasArduino: portasDisponiveis,
        onPortasChanged: (String novaPorta) {
          atualizaJson('automacao', 'Sensores', 'porta', conexao1Porta);
        });

    // return AutomacaoCampo(
    //     campo: 'Sensores',
    //     placeholder: conexao1Porta.toString(),
    //     portasArduino: portasDisponiveis,
    //     onPortasChanged: (String novaPorta) {
    //       atualizaJson('automacao', 'Sensores', 'porta', conexao1Porta);
    //     });
  }
}
