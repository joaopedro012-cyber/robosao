// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_classic/flutter_blue_classic.dart';
// import 'package:flutter_joystick/flutter_joystick.dart';

// class ConexaoMotorVertical extends StatefulWidget {
//   const ConexaoMotorVertical({super.key, required this.connection});

//   final BluetoothConnection connection;

//   @override
//   State<ConexaoMotorVertical> createState() => _ConexaoMotorVerticalState();
// }

// const ballSize = 20.0;
// const step = 10.0;

// class _ConexaoMotorVerticalState extends State<ConexaoMotorVertical> {
//   double _x = 100;
//   double _y = 100;
//   JoystickMode _joystickModeVertical = JoystickMode.vertical;

//   StreamSubscription? _readSubscriptionVertical;
//   final List<String> _receivedInput = [];

//   @override
//   void didChangeDependencies() {
//     _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     _readSubscriptionVertical = widget.connection.input?.listen((event) {
//       if (mounted) {
//         setState(() => _receivedInput.add(utf8.decode(event)));
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     widget.connection.dispose();
//     _readSubscriptionVertical?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//             child: Wrap(
//               direction: Axis.horizontal,
//               alignment: WrapAlignment.spaceBetween,
//               children: [
//                 Container(
//                   child: Joystick(
//                     mode: _joystickModeVertical,
//                     includeInitialAnimation: false,
//                     stick: const CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.white,
//                     ),
//                     listener: (details) {
//                       setState(() {
//                         double valorVertical = details.y;

//                         switch (valorVertical) {
//                           case >= 0.000000000000001:
//                             widget.connection.writeString("x");
//                             if (kDebugMode) {
//                               print("Valor de Y: é positivo $valorVertical");
//                             }
//                             break;
//                           case <= -0.000000000000001:
//                             widget.connection.writeString("w");
//                             if (kDebugMode) {
//                               print("Valor de Y: é negativo $valorVertical");
//                             }
//                         }

//                         _y = _y + step * details.y;
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
