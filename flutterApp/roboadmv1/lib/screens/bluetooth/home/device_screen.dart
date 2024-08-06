import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothConnection connection1;
  final BluetoothConnection connection2;

  const DeviceScreen(
      {super.key, required this.connection1, required this.connection2});
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

const ballSize = 20.0;
const step = 10.0;

class _DeviceScreenState extends State<DeviceScreen> {
  double _x = 100;
  double _y = 100;
  final JoystickMode _joystickModeHorizontal = JoystickMode.horizontal;
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
    _readSubscription = widget.connection1.input?.listen((event) {
      if (mounted) {
        setState(() => _receivedInput.add(utf8.decode(event)));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.connection1.dispose();
    _readSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conectado ao ${widget.connection1.address}"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 1000,
            height: 70,
            color: Colors.blue,
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Joystick(
                mode: _joystickModeVertical,
                includeInitialAnimation: false,
                stick: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                ),
                listener: (details) {
                  setState(() {
                    double valorVertical = details.y;

                    switch (valorVertical) {
                      case >= 0.000000000000001:
                        widget.connection1.writeString("x");
                        if (kDebugMode) {
                          print("Valor de Y: é positivo $valorVertical");
                        }
                        break;
                      case <= -0.000000000000001:
                        widget.connection1.writeString("w");
                        if (kDebugMode) {
                          print("Valor de Y: é negativo $valorVertical");
                        }
                    }

                    _y = _y + step * details.y;
                  });
                },
              ),
              FractionallySizedBox(
                widthFactor: 0.65,
                child: Container(
                  color: Colors.green,
                  // Seu conteúdo aqui
                ),
              ),
              Joystick(
                mode: _joystickModeHorizontal,
                includeInitialAnimation: false,
                stick: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                ),
                listener: (details) {
                  setState(() {
                    double valorHorizontal = details.x;

                    switch (valorHorizontal) {
                      case >= 0.000000000000001:
                        widget.connection2.writeString("d");
                        if (kDebugMode) {
                          print("Valor de X: é positivo $valorHorizontal");
                        }
                        break;
                      case <= -0.000000000000001:
                        widget.connection2.writeString("a");
                        if (kDebugMode) {
                          print("Valor de X: é negativo $valorHorizontal");
                        }
                    }

                    _x = _x + step * details.x;
                  });
                },
              ),
            ],
          ),
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
