import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'package:roboadmv1/screens/bluetooth/home/home.dart';
import 'package:roboadmv1/screens/testes/testes.dart';
import 'package:roboadmv1/screens/controle/controle.dart';

void main() {
  runApp(const RoboApp());
}

class RoboApp extends StatelessWidget {
  const RoboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomePage(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/BluetoothPage': (context) => const BluetoothPage(),
        '/ControlePage': (context) => const ControlePage(),
        '/TestesPage': (context) => const TestesPage(),
      },
    );
  }
}
