import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:roboadmv1/database/db.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothConnection connection1;
  final BluetoothConnection connection2;

  const DeviceScreen(
      {super.key, required this.connection1, required this.connection2});
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int wContador = 0;
  int xContador = 0;
  int aContador = 0;
  int dContador = 0;
  bool wPressionado = false;
  bool xPressionado = false;
  bool aPressionado = false;
  bool dPressionado = false;


  StreamSubscription? _readSubscription;
  final List<String> _receivedInput = [];

  
  void incrementaContador(String btnPressionado) {
    setState(() {
      switch (btnPressionado) {
        case 'w':
          if (wPressionado) {
            wContador++;
            if (kDebugMode) {
              print("w contador é $wContador");
            }
          }
          break;
        case 'x':
          if (xPressionado) {
            xContador++;
            if (kDebugMode) {
              print("x contador é $xContador");
            }
          }
          break;
        case 'a':
          if (aPressionado) {
            aContador++;
            if (kDebugMode) {
              print("a contador é $aContador");
            }
          }
          break;
        case 'd':
          if (dPressionado) {
            dContador++;
            if (kDebugMode) {
              print("d contador é $dContador");
            }
          }
          break;
      }
    });
  }

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
    const JoystickMode joystickModeHorizontal = JoystickMode.horizontal;
    const JoystickMode joystickModeVertical = JoystickMode.vertical;
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
                        mode: joystickModeVertical,
                        includeInitialAnimation: false,
                        stick: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                        ),
                        listener: (details) {
                          setState(() {
                            double valorVertical = details.y;
                            double valorHorizontal = details.x;

                            if (valorVertical > 0.000000000000001) {
                              wPressionado = false;
                              xPressionado = true;
                              incrementaContador('x');
                                                          widget.connection1.writeString("x");

                            } else if (valorVertical < -0.000000000000001) {
                              xPressionado = false;
                              wPressionado = true;
                              incrementaContador('w');
                              widget.connection1.writeString("w");
                            } else {
                              if (wPressionado) {
                                wPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'w',
                                    wContador); // Substitua '1' por seu ID_ROTINA real
                                wContador = 0; // Reseta o contador após inserir
                              }

                              if (xPressionado) {
                                xPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'x',
                                    xContador); // Substitua '1' por seu ID_ROTINA real
                                xContador = 0; // Reseta o contador após inserir
                              }
                            }

                            if (valorHorizontal > 0.000000000000001) {
                              dPressionado = true;
                              aPressionado = false;
                              incrementaContador('d');
                               widget.connection2.writeString("d");
                            } else if (valorHorizontal < -0.000000000000001) {
                              aPressionado = true;
                              dPressionado = false;
                              incrementaContador('a');
                              widget.connection2.writeString("a");
                            } else {
                              if (dPressionado) {
                                dPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'd',
                                    dContador); // Substitua '1' por seu ID_ROTINA real
                                dContador = 0; // Reseta o contador após inserir
                              }

                              if (aPressionado) {
                                aPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'a',
                                    aContador); // Substitua '1' por seu ID_ROTINA real
                                aContador = 0; // Reseta o contador após inserir
                              }
                            }

                            // Logs para depuração
                            if (kDebugMode) {
                              print(
                                  "Valor Vertical: $valorVertical, wPressionado: $wPressionado, xPressionado: $xPressionado");
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
                        mode: joystickModeHorizontal,
                        includeInitialAnimation: false,
                        stick: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                        ),
                        listener: (details) {
                          setState(() {
                            double valorHorizontal = details.x;

                            if (valorHorizontal > 0.000000000000001) {
                              aPressionado = false;
                              dPressionado = true;
                              incrementaContador('d');
                            } else if (valorHorizontal < -0.000000000000001) {
                              dPressionado = false;
                              aPressionado = true;
                              incrementaContador('a');
                            } else {
                              if (aPressionado) {
                                aPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'a',
                                    aContador); // Substitua '1' por seu ID_ROTINA real
                                aContador = 0; // Reseta o contador após inserir
                              }

                              if (dPressionado) {
                                dPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'd',
                                    dContador); // Substitua '1' por seu ID_ROTINA real
                                dContador = 0; // Reseta o contador após inserir
                              }
                            }

                            if (valorHorizontal > 0.000000000000001) {
                              dPressionado = true;
                              aPressionado = false;
                              incrementaContador('d');
                              
                            } else if (valorHorizontal < -0.000000000000001) {
                              aPressionado = true;
                              dPressionado = false;
                              incrementaContador('a');
                            } else {
                              if (dPressionado) {
                                dPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'd',
                                    dContador); // Substitua '1' por seu ID_ROTINA real
                                dContador = 0; // Reseta o contador após inserir
                              }

                              if (aPressionado) {
                                aPressionado = false;
                                // Insira no banco quando o joystick é solto
                                DB.insertExecucaoRotina(1, 'a',
                                    aContador); // Substitua '1' por seu ID_ROTINA real
                                aContador = 0; // Reseta o contador após inserir
                              }
                            }

                            // Logs para depuração
                            if (kDebugMode) {
                              print(
                                  "Valor Horizontal: $valorHorizontal, aPressionado: $aPressionado, dPressionado: $dPressionado");
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
