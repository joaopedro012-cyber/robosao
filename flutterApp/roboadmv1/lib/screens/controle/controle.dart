import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';
//import 'package:roboadmv1/screens/bluetooth/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ControlePage());
}

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  Future<void> insertExecucaoRotina(
      int idRotina, String acao, int qtdSinais) async {
    await DB.insertExecucaoRotina(idRotina, acao, qtdSinais);
  }

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  int wContador = 0;
  int xContador = 0;
  int aContador = 0;
  int dContador = 0;
  bool wPressionado = false;
  bool xPressionado = false;
  bool aPressionado = false;
  bool dPressionado = false;

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

  void resetarContadores(String contadorParaReset) {
    setState(() {
      switch (contadorParaReset) {
        case 'w':
          wContador = 0;
          break;
        case 'x':
          xContador = 0;
          break;
        case 'a':
          aContador = 0;
          break;
        case 'd':
          dContador = 0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const JoystickMode joystickModeHorizontal = JoystickMode.horizontal;
    const JoystickMode joystickModeVertical = JoystickMode.vertical;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerLarguraPadrao = screenWidth * 0.98;
    double larguraAlturaJoystick = screenWidth * 0.20;
    double containerInferior = screenHeight * 0.55;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Controle'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: containerLarguraPadrao,
                height: 75,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.green,
                    ),
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: containerLarguraPadrao,
                height: containerInferior,
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
                            } else if (valorVertical < -0.000000000000001) {
                              xPressionado = false;
                              wPressionado = true;
                              incrementaContador('w');
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
                                  "Valor Vertical: $valorVertical, wPressionado: $wPressionado, xPressionado: $xPressionado");
                             }
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: larguraAlturaJoystick,
                          color: Colors.yellow,
                        ),
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
        ),
      ),
    );
  }
}
