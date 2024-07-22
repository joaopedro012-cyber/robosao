import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

void main() {
  runApp(const TestesPage());
}

const ballSize = 50.0;
const step = 50.0;

class TestesPage extends StatefulWidget {
  const TestesPage({super.key});

  @override
  State<TestesPage> createState() => _TestesPageState();
}

class _TestesPageState extends State<TestesPage> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickModeHorizontal = JoystickMode.horizontal;
  JoystickMode _joystickModeVertical = JoystickMode.vertical;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        title: const Text("JOYSTICKS V2"),
        // actions: [
        //   JoystickModeDropdown(
        //     mode: _joystickModeHorizontal,
        //     onChanged: (JoystickMode value) {
        //       setState(() {
        //         _joystickModeHorizontal = value;
        //       });
        //     },s
        //   ),
        // ],
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
                    stick: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                    ),
                    includeInitialAnimation: false,
                    listener: (details) {
                      setState(() {
                        double valorVertical = details.y;

                        switch (valorVertical) {
                          case >= 0.000000000000001:
                            if (kDebugMode) {
                              //widget.connection.writeString("x");
                              print("Valor de Y: é positivo $valorVertical");
                            }
                            break;
                          case <= -0.000000000000001:
                            if (kDebugMode) {
                              //widget.connection.writeString("w");
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
                              //widget.connection.writeString("d");
                              print("Valor de X: é positivo $valorHorizontal");
                            }
                            break;
                          case <= -0.000000000000001:
                            if (kDebugMode) {
                              //widget.connection.writeString("a");
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
        ],
      ),
    );
  }
}

// class JoystickModeDropdown extends StatelessWidget {
//   final JoystickMode mode;
//   final ValueChanged<JoystickMode> onChanged;

//   const JoystickModeDropdown(
//       {super.key, required this.mode, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 150,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 16.0),
//         child: FittedBox(
//           child: DropdownButton(
//             value: mode,
//             onChanged: (v) {
//               onChanged(v as JoystickMode);
//             },
//             items: const [
//               DropdownMenuItem(
//                   value: JoystickMode.all, child: Text('All Directions')),
//               DropdownMenuItem(
//                   value: JoystickMode.horizontalAndVertical,
//                   child: Text('Vertical And Horizontal')),
//               DropdownMenuItem(
//                   value: JoystickMode.horizontal, child: Text('Horizontal')),
//               DropdownMenuItem(
//                   value: JoystickMode.vertical, child: Text('Vertical')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Button extends StatelessWidget {
//   final String label;
//   final VoidCallback? onPressed;

//   const Button({super.key, required this.label, this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: Text(label),
//       ),
//     );
//   }
// }

// class Ball extends StatelessWidget {
//   final double x;
//   final double y;

//   const Ball(this.x, this.y, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: x,
//       top: y,
//       child: Container(
//         width: ballSize,
//         height: ballSize,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.redAccent,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               spreadRadius: 2,
//               blurRadius: 3,
//               offset: Offset(0, 3),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
