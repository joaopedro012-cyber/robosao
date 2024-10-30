import 'package:flutter/material.dart';
import '../buttons/button_icon.dart';
import '../screens/bluetooth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/bluetoothpage': (context) => const bluetoothPage(),
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Administração Robo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Wrap(
          spacing: 16,
          children: [
            BotaoComIcone(
              icone: Icons.bluetooth,
              textoIcone: 'BLUETOOTH',
              corDeFundo: const Color(0xFF7171d5),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
            BotaoComIcone(
              icone: Icons.computer_outlined,
              textoIcone: 'COMPUTADOR',
              corDeFundo: const Color(0xFF8d40b7),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
            BotaoComIcone(
              icone: Icons.sports_esports,
              textoIcone: 'CONTROLE',
              corDeFundo: const Color(0xFF42b7ac),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
            BotaoComIcone(
              icone: Icons.build,
              textoIcone: 'MANUTENÇÃO',
              corDeFundo: const Color(0xFFd5ac4d),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
            BotaoComIcone(
              icone: Icons.list,
              textoIcone: 'ROTINAS',
              corDeFundo: const Color(0xFFd57171),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
            BotaoComIcone(
              icone: Icons.radar,
              textoIcone: 'SENSORES',
              corDeFundo: const Color(0xFF9ac847),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetoothpage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
