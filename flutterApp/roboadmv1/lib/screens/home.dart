import 'package:flutter/material.dart';
import 'package:roboadmv1/screens/bluetooth/home/home.dart';
import 'package:roboadmv1/screens/controle/controle.dart';
import 'package:roboadmv1/screens/testes/testes.dart';
import '../buttons/button_icon.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Administração Robo',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothPage(),
                    ),
                  );
                },
              ),
              BotaoComIcone(
                icone: Icons.computer_outlined,
                textoIcone: 'PC',
                corDeFundo: const Color(0xFF8d40b7),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothPage(),
                    ),
                  );
                },
              ),
              BotaoComIcone(
                  icone: Icons.sports_esports,
                  textoIcone: 'CONTROLE',
                  corDeFundo: const Color.fromARGB(255, 78, 78, 78),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ControlePage(),
                      ),
                    );
                  }),
              BotaoComIcone(
                  icone: Icons.build,
                  textoIcone: 'TESTES',
                  corDeFundo: const Color(0xFFd5ac4d),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestesPage(),
                      ),
                    );
                  }),
              BotaoComIcone(
                icone: Icons.list,
                textoIcone: 'ROTINAS',
                corDeFundo: const Color(0xFFd57171),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothPage(),
                    ),
                  );
                },
              ),
              BotaoComIcone(
                icone: Icons.radar,
                textoIcone: 'SENSORES',
                corDeFundo: const Color(0xFF9ac847),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
