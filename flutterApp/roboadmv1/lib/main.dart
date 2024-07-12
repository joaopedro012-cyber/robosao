import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'package:roboadmv1/screens/bluetooth/home/home.dart';
import 'package:roboadmv1/screens/controle/controle.dart';

void main() {
  runApp(const roboApp());
}

class roboApp extends StatelessWidget {
  const roboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const homePage(),
      routes: {
        '/homepage': (context) => const homePage(),
        '/BluetoothPage': (context) => const BluetoothPage(),
        '/ControlePage': (context) => const ControlePage(),
      },
    );
  }
}
