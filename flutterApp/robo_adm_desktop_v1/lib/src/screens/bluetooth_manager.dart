import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class BluetoothDesktopPage extends StatefulWidget {
  const BluetoothDesktopPage({super.key});

  @override
  State<BluetoothDesktopPage> createState() => _BluetoothDesktopPageState();
}

class _BluetoothDesktopPageState extends State<BluetoothDesktopPage> {
  List<String> availablePorts = [];
  Map<String, SerialPort> connectedPorts = {}; // Para armazenar várias conexões
  Map<String, bool> isConnected = {}; // Controle de conexão por porta

  @override
  void initState() {
    super.initState();
    listAvailablePorts();
  }

  // Lista as portas disponíveis no computador
  void listAvailablePorts() {
    setState(() {
      availablePorts = SerialPort.availablePorts;
    });
  }

  // Conectar a uma porta selecionada
  void connectToPort(String portName) {
    try {
      final port = SerialPort(portName);

      // Tenta abrir a porta para leitura e escrita
      if (!port.openReadWrite()) {
        throw SerialPort.lastError ??
            'Erro desconhecido ao tentar abrir a porta';
      }

      final config = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none;

      // Configura a porta com as opções
      port.config = config;

      setState(() {
        connectedPorts[portName] = port;
        isConnected[portName] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conectado à porta: $portName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar à porta: $e')),
      );
    }
  }

  // Desconectar de uma porta
  void disconnectPort(String portName) {
    if (connectedPorts.containsKey(portName)) {
      connectedPorts[portName]!.close();
      setState(() {
        connectedPorts.remove(portName);
        isConnected[portName] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Desconectado da porta: $portName')),
      );
    }
  }

  // Enviar comando para o robô
  void sendCommand(String command, String portName) {
    if (!isConnected.containsKey(portName) || !isConnected[portName]!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma porta conectada!')),
      );
      return;
    }

    try {
      // Envia o comando para a porta serial
      connectedPorts[portName]!.write(Uint8List.fromList(command.codeUnits));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comando enviado para $portName: $command')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar comando para $portName: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexão Bluetooth (Desktop)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: listAvailablePorts,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: availablePorts.length,
              itemBuilder: (context, index) {
                final portName = availablePorts[index];
                return ListTile(
                  title: Text(portName),
                  leading: Checkbox(
                    value: isConnected[portName] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          connectToPort(portName);
                        } else {
                          disconnectPort(portName);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ...connectedPorts.keys.map((portName) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Conectado à porta: $portName'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        sendCommand('w', portName), // Mover para frente
                    child: const Text('Enviar comando: w'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('x', portName), // Parar
                    child: const Text('Enviar comando: x'),
                  ),
                  ElevatedButton(
                    onPressed: () => disconnectPort(portName),
                    child: const Text('Desconectar'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
