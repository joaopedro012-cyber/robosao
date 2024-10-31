import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class MonitorSerial extends StatefulWidget {
  final SerialPort portaConexao;
  const MonitorSerial({super.key, required this.portaConexao});

  @override
  State<MonitorSerial> createState() => _MonitorSerialState();
}

class _MonitorSerialState extends State<MonitorSerial> {
  Future<String>? valorRecebido;
  SerialPortReader? reader;

  @override
  void initState() {
    super.initState();
    inicializarComunicacao();
  }

  Future<void> inicializarComunicacao() async {
    await Future.delayed(const Duration(milliseconds: 500), 
        () => inicializadorSerialPort(widget.portaConexao));

    await Future.delayed(const Duration(milliseconds: 100), 
        () => enviaDadosSerialPort(widget.portaConexao, "ola\n"));

    setState(() {
      valorRecebido = exibeDadosSerialPort(widget.portaConexao);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: valorRecebido,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Text('Resposta: ${snapshot.data}');
        } else {
          return const Text("Nenhum dado recebido.");
        }
      },
    );
  }
}
