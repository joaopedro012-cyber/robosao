import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/bluetooth.dart';

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
        '/bluetoothpage': (context) => const bluetoothPage(),
      },
    );
  }
}
