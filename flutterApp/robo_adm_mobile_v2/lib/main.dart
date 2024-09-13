import 'package:flutter/material.dart';
import 'src/screens/bluetooth.dart';
import 'src/screens/controle.dart';
import 'src/screens/rotinas.dart';
import 'src/screens/testes.dart';
import 'src/screens/home.dart';
void main() {
  runApp(const Teste());
}
class Teste extends StatelessWidget {
  const Teste({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', 
      routes: {
        '/': (context) => const Teste1234(),             
        '/testes': (context) =>  const Testetela(),     
        '/rotinas': (context) =>   const Telarotina(),   
        '/controle': (context) =>  const Teladecontrole(), 
        '/bluetooth': (context) =>  const TelaBluetooth(), 
      },
    );
  }
}
