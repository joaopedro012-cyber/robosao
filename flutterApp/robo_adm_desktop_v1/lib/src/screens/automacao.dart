import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:libserialport/libserialport.dart';

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  @override
  Widget build(BuildContext context) {
    List<String> portasConectadas = SerialPort.availablePorts;

    if (kDebugMode) {
      print('Portas sendo utilizadas: $portasConectadas');
    }
    return const Text('Puxou Automação');
  }
}
