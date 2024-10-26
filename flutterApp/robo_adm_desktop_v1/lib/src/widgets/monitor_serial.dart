import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

//MANDAR "OLA" PARA TESTAR
class MonitorSerial extends StatefulWidget {
  final SerialPort portaConexao;
  const MonitorSerial({super.key, required this.portaConexao});

  @override
  State<MonitorSerial> createState() => _MonitorSerialState();
}

class _MonitorSerialState extends State<MonitorSerial> {
  Future<String>? valorRecebido;
  SerialPortReader? reader;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 500),
        () => inicializadorSerialPort(widget.portaConexao));
    timer = Timer(const Duration(milliseconds: 600),
        () => enviaDadosSerialPort(widget.portaConexao, "ola\n"));
    timer = Timer(const Duration(milliseconds: 700),
        () => valorRecebido = exibeDadosSerialPort(widget.portaConexao));
  }

  @override
  Widget build(BuildContext context) {
    return const Text("o console entrega");
  }
}
