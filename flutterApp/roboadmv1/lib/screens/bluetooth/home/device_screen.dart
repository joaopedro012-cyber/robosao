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

const ballSize = 20.0;
const step = 10.0;

class _DeviceScreenState extends State<DeviceScreen> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickModeHorizontal = JoystickMode.horizontal;
  JoystickMode _joystickModeVertical = JoystickMode.vertical;

  StreamSubscription? _readSubscription;
  final List<String> _receivedInput = [];

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

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
      body: Column(
        children: <Widget>[
          Container(
            width: 1000,
            height: 70,
            color: Colors.blue,
          ),
          Container(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Container(
                  child: Joystick(
                    mode: _joystickModeVertical,
                    includeInitialAnimation: false,
                    listener: (details) {
                      setState(() {
                        double valorVertical = details.y;

                        switch (valorVertical) {
                          case >= 0.000000000000001:
                            if (kDebugMode) {
                              widget.connection.writeString("x");
                              print("Valor de Y: é positivo $valorVertical");
                            }
                            break;
                          case <= -0.000000000000001:
                            if (kDebugMode) {
                              widget.connection.writeString("w");
                              print("Valor de Y: é negativo $valorVertical");
                            }
                        }

                        _y = _y + step * details.y;
                      });
                    },
                  ),
                ),
                Container(
                  child: FractionallySizedBox(
                    widthFactor: 0.45,
                    child: Container(
                      color: Colors.green,
                      // Seu conteúdo aqui
                    ),
                  ),
                ),
                Container(
                  child: Joystick(
                    mode: _joystickModeHorizontal,
                    includeInitialAnimation: false,
                    listener: (details) {
                      setState(() {
                        double valorHorizontal = details.x;
                        //double valorVertical = details.y;

                        switch (valorHorizontal) {
                          case >= 0.000000000000001:
                            if (kDebugMode) {
                              widget.connection.writeString("d");
                              print("Valor de X: é positivo $valorHorizontal");
                            }
                            break;
                          case <= -0.000000000000001:
                            if (kDebugMode) {
                              widget.connection.writeString("a");
                              print("Valor de X: é negativo $valorHorizontal");
                            }
                        }

                        _x = _x + step * details.x;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //         double valorVertical = details.y;

          //         switch (valorHorizontal) {
          //           case >= 0.000000000000001:
          //             widget.connection.writeString("d");

          //             if (kDebugMode) {
          //               print("Valor de X: é positivo $valorHorizontal");
          //             }
          //             break;
          //           case <= -0.000000000000001:
          //             widget.connection.writeString("a");

          //             if (kDebugMode) {
          //               print("Valor de X: é negativo $valorHorizontal");
          //             }
          //         }
          //         switch (valorVertical) {
          //           case >= 0.000000000000001:
          //             widget.connection.writeString("x");

          //             if (kDebugMode) {
          //               print("Valor de Y: é positivo $valorVertical");
          //             }
          //             break;
          //           case <= -0.000000000000001:
          //             widget.connection.writeString("w");

          //             if (kDebugMode) {
          //               print("Valor de Y: é negativo $valorVertical");
          //             }
          //         }
          //       });
          //     },
          //   ),
          // ),
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
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text("Dados Recebidos",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          for (String input in _receivedInput) Text(input),
        ],
      ),
    );
  }
}
