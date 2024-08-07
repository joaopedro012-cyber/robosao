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

class _DeviceScreenState extends State<DeviceScreen> {
  final JoystickMode _joystickModeHorizontal = JoystickMode.horizontal;
  final JoystickMode _joystickModeVertical = JoystickMode.vertical;

  StreamSubscription? _readSubscription;
  final List<String> _receivedInput = [];

  @override
  void didChangeDependencies() {
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerLarguraPadrao = screenWidth * 0.98;
    double larguraAlturaJoystick = screenWidth * 0.20;
    double containerSuperior = screenHeight * 0.30;
    double containerInferior = screenHeight * 0.55;
    return Scaffold(
      appBar: AppBar(
        title: Text("Conectado ao ${widget.connection1.address}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: containerLarguraPadrao,
            height: containerSuperior,
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //TELA
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.green,
                ),
                //DADOS EM TEMPO REAL
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Container(
            width: containerLarguraPadrao,
            height: containerInferior,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Joystick Cima e Baixo
                Container(
                  width: larguraAlturaJoystick,
                  height: larguraAlturaJoystick,
                  color: Colors.white54,
                  child: Joystick(
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
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Plataforma
                    Container(
                      width: 50,
                      height: larguraAlturaJoystick,
                      color: Colors.yellow,
                    ),
                    //Tomadas
                    Container(
                      width: 150,
                      height: larguraAlturaJoystick,
                      color: Colors.pink,
                    ),
                  ],
                ),
                //Joystick esquerda e direita
                Container(
                  width: larguraAlturaJoystick,
                  height: larguraAlturaJoystick,
                  color: Colors.white,
                  child: Joystick(
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
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/*
  NOVA VERSÃO
 */
