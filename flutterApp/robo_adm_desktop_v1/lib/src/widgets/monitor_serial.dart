import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';

class MonitorSerial extends StatefulWidget {
  final String portaConexao;
  const MonitorSerial({super.key, required this.portaConexao});

  @override
  State<MonitorSerial> createState() => _MonitorSerialState();
}

class _MonitorSerialState extends State<MonitorSerial> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            exibeConsole(widget.portaConexao),
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
