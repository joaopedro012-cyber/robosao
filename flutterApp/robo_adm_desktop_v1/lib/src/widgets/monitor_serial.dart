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
  Future<String>? valorRecebido; // Usado para exibir os dados recebidos.
  SerialPortReader? reader;
  String consoleText = ""; // Para armazenar os dados de console

  @override
  void initState() {
    super.initState();
    inicializarComunicacao();
  }

  // Inicializa a comunicação serial com o Arduino
  Future<void> inicializarComunicacao() async {
    // Configura a porta serial para leitura e escrita
    await Future.delayed(const Duration(milliseconds: 500),
        () => inicializadorSerialPort(widget.portaConexao));

    // Envia um dado de exemplo ao Arduino
    await Future.delayed(const Duration(milliseconds: 100),
        () => enviaDadosSerialPort(widget.portaConexao, "ola\n"));

    // A partir de agora, começamos a escutar os dados recebidos
    setState(() {
      valorRecebido = exibeDadosSerialPort(widget.portaConexao);
    });
  }

  // Função para exibir dados recebidos via serial
  Future<String> exibeDadosSerialPort(final SerialPort portaConexao) async {
    final Completer<String> completer = Completer<String>();
    final reader = SerialPortReader(portaConexao);

    // String para armazenar dados recebidos do Arduino
    String received = "Nenhum dado recebido.";

    reader.stream.listen((data) {
      // Converte os dados binários para uma string
      received = String.fromCharCodes(data);
      completer.complete(received); // Completa o futuro com os dados recebidos
      setState(() {
        consoleText = received; // Atualiza o texto da console com a resposta
      });
    }, onError: (error) {
      print('Erro ao ler os dados da porta serial: $error');
      completer.completeError(error);
    });

    return completer
        .future; // Retorna o futuro que vai ser preenchido com os dados
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exibe a área de monitoramento serial
        const Text(
          'Console Serial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        // Aqui será exibido o texto recebido na comunicação serial
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Text(
              consoleText, // Exibe o texto da variável consoleText
              style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
