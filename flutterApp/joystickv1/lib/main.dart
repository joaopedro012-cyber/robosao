import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/bluetooth.dart';

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
        '/bluetoothpage': (context) => const bluetoothPage(),
      },
    );
  }
}
