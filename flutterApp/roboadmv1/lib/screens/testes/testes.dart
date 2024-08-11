import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
//import 'package:roboadmv1/screens/bluetooth/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const TestesPage());
}

class TestesPage extends StatefulWidget {
  const TestesPage({super.key});

  @override
  State<TestesPage> createState() => _TestesPageState();
}

class _TestesPageState extends State<TestesPage> {
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

                            switch (valorVertical) {
                              case >= 0.000000000000001:
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

// import 'package:flutter/material.dart';
// import 'package:flutter_joystick/flutter_joystick.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   runApp(const TestesPage());
// }

// const ballSize = 50.0;
// const step = 50.0;

// class TestesPage extends StatefulWidget {
//   const TestesPage({super.key});

//   @override
//   State<TestesPage> createState() => _TestesPageState();
// }

// class _TestesPageState extends State<TestesPage> {
//   double _x = 100;
//   double _y = 100;
//   JoystickMode joystickModeHorizontal = JoystickMode.horizontal;
//   JoystickMode joystickModeVertical = JoystickMode.vertical;

//   @override
//   void didChangeDependencies() {
//     _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
//       appBar: AppBar(
//         title: const Text("JOYSTICKS V2"),
//         // actions: [
//         //   JoystickModeDropdown(
//         //     mode: joystickModeHorizontal,
//         //     onChanged: (JoystickMode value) {
//         //       setState(() {
//         //         joystickModeHorizontal = value;
//         //       });
//         //     },s
//         //   ),
//         // ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             width: 1000,
//             height: 120,
//             color: Colors.blue,
//           ),
//           Container(
//             child: Wrap(
//               direction: Axis.horizontal,
//               alignment: WrapAlignment.center,
//               children: [
//                 Container(
//                   child: Joystick(
//                     mode: joystickModeVertical,
//                     stick: const CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.white,
//                     ),
//                     includeInitialAnimation: false,
//                     listener: (details) {
//                       setState(() {
//                         double valorVertical = details.y;

//                         switch (valorVertical) {
//                           case >= 0.000000000000001:
//                             if (kDebugMode) {
//                               //widget.connection.writeString("x");
//                               print("Valor de Y: é positivo $valorVertical");
//                             }
//                             break;
//                           case <= -0.000000000000001:
//                             if (kDebugMode) {
//                               //widget.connection.writeString("w");
//                               print("Valor de Y: é negativo $valorVertical");
//                             }
//                         }

//                         _y = _y + step * details.y;
//                       });
//                     },
//                   ),
//                 ),
//                 Container(
//                   child: FractionallySizedBox(
//                     widthFactor: 0.65,
//                     child: Container(
//                       color: Colors.green,
//                       // Seu conteúdo aqui
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: Joystick(
//                     mode: joystickModeHorizontal,
//                     includeInitialAnimation: false,
//                     listener: (details) {
//                       setState(() {
//                         double valorHorizontal = details.x;
//                         //double valorVertical = details.y;

//                         switch (valorHorizontal) {
//                           case >= 0.000000000000001:
//                             if (kDebugMode) {
//                               //widget.connection.writeString("d");
//                               print("Valor de X: é positivo $valorHorizontal");
//                             }
//                             break;
//                           case <= -0.000000000000001:
//                             if (kDebugMode) {
//                               //widget.connection.writeString("a");
//                               print("Valor de X: é negativo $valorHorizontal");
//                             }
//                         }

//                         _x = _x + step * details.x;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class JoystickModeDropdown extends StatelessWidget {
// //   final JoystickMode mode;
// //   final ValueChanged<JoystickMode> onChanged;

// //   const JoystickModeDropdown(
// //       {super.key, required this.mode, required this.onChanged});

// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 150,
// //       child: Padding(
// //         padding: const EdgeInsets.only(left: 16.0),
// //         child: FittedBox(
// //           child: DropdownButton(
// //             value: mode,
// //             onChanged: (v) {
// //               onChanged(v as JoystickMode);
// //             },
// //             items: const [
// //               DropdownMenuItem(
// //                   value: JoystickMode.all, child: Text('All Directions')),
// //               DropdownMenuItem(
// //                   value: JoystickMode.horizontalAndVertical,
// //                   child: Text('Vertical And Horizontal')),
// //               DropdownMenuItem(
// //                   value: JoystickMode.horizontal, child: Text('Horizontal')),
// //               DropdownMenuItem(
// //                   value: JoystickMode.vertical, child: Text('Vertical')),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Button extends StatelessWidget {
// //   final String label;
// //   final VoidCallback? onPressed;

// //   const Button({super.key, required this.label, this.onPressed});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: ElevatedButton(
// //         onPressed: onPressed,
// //         child: Text(label),
// //       ),
// //     );
// //   }
// // }

// // class Ball extends StatelessWidget {
// //   final double x;
// //   final double y;

// //   const Ball(this.x, this.y, {super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Positioned(
// //       left: x,
// //       top: y,
// //       child: Container(
// //         width: ballSize,
// //         height: ballSize,
// //         decoration: const BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: Colors.redAccent,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black12,
// //               spreadRadius: 2,
// //               blurRadius: 3,
// //               offset: Offset(0, 3),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
