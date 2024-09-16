import 'package:flutter/material.dart';
import 'src/screens/home.dart';
import 'src/screens/bluetooth.dart';
import 'src/screens/controle.dart';
import 'src/screens/rotinas.dart';
import 'src/screens/testes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/controle': (context) => const ControlePage(),
        '/bluetooth': (context) => const BluetoothPage(),
        '/rotinas': (context) => const Telarotina(),
        '/testes': (context) => const Testetela(),
      },
    );
  }
}
