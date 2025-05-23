import 'dart:async';  
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:robo_adm_mobile_v2/src/database/db.dart';
import 'controle.dart';


class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key, required this.connection});

  final BluetoothConnection connection;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}


class _DeviceScreenState extends State<DeviceScreen> {
  StreamSubscription? _readSubscription;
  final List<String> _receivedInput = [];

  @override
  void initState() {
    super.initState();
    _readSubscription = widget.connection.input?.listen((event) {
      if (mounted) {
        setState(() => _receivedInput.add(utf8.decode(event)));
      }
    });
  }

  @override
  void dispose() {
    widget.connection.dispose();
    _readSubscription?.cancel();
    super.dispose();
  }

  Future<void> sendCommand(String command) async {
    if (widget.connection.isConnected) {
      try {
        // Se writeString retornar void, remova o await
        widget.connection.writeString(command); // Remova await se não retornar Future

        // Certifique-se de que insertExecucaoRotina retorna Future<void>
        await DB.instance.insertExecucaoRotina( // Substitua DB.instance pelo construtor correto
          idRotina: int.parse(ControlePageState.selectedRoutine!),
          acaoHorizontal: SendBD.acaoHorizontal,
          qtdHorizontal: SendBD.qtdHorizontal,
          acaoVertical: SendBD.acaoVertical,
          qtdVertical: SendBD.qtdVertical,
          acaoPlataforma: SendBD.acaoPlataforma,
          qtdPlataforma: SendBD.qtdPlataforma,
          acaoBotao1: SendBD.acaoBotao1,
          qtdBotao1: SendBD.qtdBotao1,
          acaoBotao2: SendBD.acaoBotao2,
          qtdBotao2: SendBD.qtdBotao2,
          dtExecucao: DateTime.now().microsecondsSinceEpoch,
        );
      } catch (e) {
        if (kDebugMode) print(e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Error sending to device. Device is ${widget.connection.isConnected ? "connected" : "not connected"}"
            ),
          ));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Device is not connected."),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connection to ${widget.connection.address}"),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => sendCommand("FORWARD"),
            child: const Text("Send FORWARD command to remote device"),
          ),
          ElevatedButton(
            onPressed: () => sendCommand("BACKWARD"),
            child: const Text("Send BACKWARD command to remote device"),
          ),
          ElevatedButton(
            onPressed: () => sendCommand("LEFT"),
            child: const Text("Send LEFT command to remote device"),
          ),
          ElevatedButton(
            onPressed: () => sendCommand("RIGHT"),
            child: const Text("Send RIGHT command to remote device"),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Received data",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          for (String input in _receivedInput) Text(input),
        ],
      ),
    );
  }
}
