import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

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
    _readSubscription = widget.connection.input?.listen((event) {
      if (mounted) {
        setState(() => _receivedInput.add(utf8.decode(event)));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.connection.dispose();
    _readSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conectado ao ${widget.connection.address}"),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: JoystickArea(
              mode: JoystickMode.all,
              includeInitialAnimation: false,
              initialJoystickAlignment: const Alignment(0, 0.8),
              listener: (details) {
                setState(() {
                  double ValorHorizontal = details.x;
                  double ValorVertical = details.y;

                  switch (ValorHorizontal) {
                    case >= 0.000000000000001:
                      widget.connection.writeString("d");
                      // String? ValorDeEnvioDireita = "D";
                      // final ValorConvertidoASCIIDireita = ValorDeEnvioDireita.codeUnitAt(0);
                      // final ValorModeloBluetoothDireita = Uint8List.fromList([ValorConvertidoASCIIDireita]);

                      print("Valor de X: é positivo $ValorHorizontal");
                      break;
                    case <= -0.000000000000001:
                      widget.connection.writeString("a");
                      // String? ValorDeEnvioEsquerda = "A";
                      // final ValorConvertidoASCIIEsquerda = ValorDeEnvioEsquerda.codeUnitAt(0);
                      // final ValorModeloBluetoothEsquerda = Uint8List.fromList([ValorConvertidoASCIIEsquerda]);

                      print("Valor de X: é negativo $ValorHorizontal");
                  }
                  switch (ValorVertical) {
                    case >= 0.000000000000001:
                      widget.connection.writeString("x");
                      // String? ValorDeEnvioAtras = "X";
                      //   final ValorConvertidoASCIIAtras = ValorDeEnvioAtras.codeUnitAt(0);
                      //   final ValorModeloBluetoothAtras = Uint8List.fromList([ValorConvertidoASCIIAtras]);
                      //   UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothAtras,BleOutputProperty.withResponse,);

                      print("Valor de Y: é positivo $ValorVertical");
                      break;
                    case <= -0.000000000000001:
                      widget.connection.writeString("w");
                      // String? ValorDeEnvioFrente = "W";
                      //   final ValorConvertidoASCIIFrente = ValorDeEnvioFrente.codeUnitAt(0);
                      //   final ValorModeloBluetoothFrente = Uint8List.fromList([ValorConvertidoASCIIFrente]);
                      //   UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothFrente,BleOutputProperty.withResponse,);

                      print("Valor de Y: é negativo $ValorVertical");
                  }
                });
              },
            ),
          ),
          // ElevatedButton(
          // onPressed: () {
          //   try {
          //     widget.connection.writeString("w");
          //   } catch (e) {
          //     if (kDebugMode) print(e);
          //     ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
          //         content: Text(
          //             "Erro ao enviar ao dispositivo. Device is ${widget.connection.isConnected ? "Conectado" : "Não Conectado"}")));
          //   }
          // },
          // child: const Text("Enviar caractere 'w'")),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Dados Recebidos",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          for (String input in _receivedInput) Text(input),
        ],
      ),
    );
  }
}
