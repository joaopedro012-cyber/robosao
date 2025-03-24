import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/providers/conexao_provider.dart';

class ArduinoController {
  SerialPort? port;
  SerialPortReader? reader;
  Function(String)? onDataReceived;

  void conectar(String portName, int baudRate, {Function(String)? onData}) {
    port = SerialPort(portName);
    if (!port!.openReadWrite()) {
      throw Exception('Falha ao abrir a porta serial.');
    }
    port!.config = SerialPortConfig()..baudRate = baudRate;
    reader = SerialPortReader(port!);
    onDataReceived = onData;

    reader!.stream.listen((data) {
      final mensagem = String.fromCharCodes(data);
      if (onDataReceived != null) {
        onDataReceived!(mensagem);
      }
    });
  }

  void sendCommand(String command) {
    if (port != null) {
      final Uint8List data = Uint8List.fromList(command.codeUnits);
      port!.write(data);
    }
  }

  void close() {
    port?.close();
  }
}

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  final ArduinoController arduino = ArduinoController();
  String dadosSensores = "Aguardando sensores...";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final conexaoProvider = Provider.of<ConexaoProvider>(context, listen: false);
    final portaSelecionada = conexaoProvider.configuracoesPortas['robo'];
    if (portaSelecionada != null) {
      arduino.conectar(portaSelecionada, 9600, onData: (String dados) {
        setState(() {
          dadosSensores = dados;
        });
      });
    }
  }

  @override
  void dispose() {
    arduino.close();
    super.dispose();
  }

  void moverFrente() => arduino.sendCommand('w');
  void moverTras() => arduino.sendCommand('x');
  void virarEsquerda() => arduino.sendCommand('a');
  void virarDireita() => arduino.sendCommand('d');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle do Robô')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sensores: $dadosSensores", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: moverFrente, child: const Text('Frente')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: virarEsquerda, child: const Text('Esquerda')),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: virarDireita, child: const Text('Direita')),
            ],
          ),
          ElevatedButton(onPressed: moverTras, child: const Text('Trás')),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConexaoProvider(),
      child: const MaterialApp(home: ControlePage()),
    ),
  );
}
