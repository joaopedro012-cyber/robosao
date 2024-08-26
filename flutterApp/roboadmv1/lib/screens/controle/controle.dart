import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
//import 'package:roboadmv1/screens/bluetooth/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ControlePage());
}

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  @override
  Widget build(BuildContext context) {
    const JoystickMode joystickModeHorizontal = JoystickMode.horizontal;
    const JoystickMode joystickModeVertical = JoystickMode.vertical;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerLarguraPadrao = screenWidth * 0.98;
    double larguraAlturaJoystick = screenWidth * 0.20;
    double containerInferior = screenHeight * 0.55;
    int wContador = 0;
    int xContador = 0;
    int aContador = 0;
    int dContador = 0;
    bool wPressionado = false;
    bool xPressionado = false;
    bool aPressionado = false;
    bool dPressionado = false;

    void incrementaContador(
      String btnPressionado,
    ) {
      switch (btnPressionado) {
        case 'w':
          if (wPressionado = true)
            wContador++;
          else
            ;
          break;
        case 'x':
          if (xPressionado = true) xContador++;
          break;
        case 'a':
          if (aPressionado = true) aContador++;
          break;
        case 'd':
          if (dPressionado = true) dContador++;
          break;
      }
    }

    void resetarContadores(contadorParaReset) {
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
          wContador = 0;
          break;
      }
    }

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
                    //TELA
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.green,
                    ),
                    //DADOS EM TEMPO REAL
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              Container(
                width: containerLarguraPadrao,
                height: containerInferior,
                //color: Colors.amber,
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

                            switch (valorVertical) {
                              case >= 0.000000000000001:
                                wPressionado = true;

                                //widget.connection1.writeString("x");
                                if (kDebugMode) {
                                  print(
                                      //  "Valor de Y: é positivo $valorVertical"
                                      "x");
                                }
                                break;
                              case <= -0.000000000000001:
                                //widget.connection1.writeString("w");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de Y: é negativo $valorVertical"
                                      "w");
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
                        mode: joystickModeHorizontal,
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
                                // widget.connection2.writeString("d");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de X: é positivo $valorHorizontal"
                                      "d");
                                }
                                break;
                              case <= -0.000000000000001:
                                //  widget.connection2.writeString("a");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de X: é negativo $valorHorizontal"
                                      "a");
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
        ),
      ),
    );
  }
}
