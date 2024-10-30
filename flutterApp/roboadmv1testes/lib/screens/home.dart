import 'package:flutter/material.dart';
import '../buttons/button_icon.dart';
import '../screens/bluetooth/home/home.dart';

void main() {
  runApp(const homePage());
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/BluetoothPage': (context) => const BluetoothPage(),
      },
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
                  Navigator.pushNamed(context, '/BluetoothPage');
                },
              ),
              BotaoComIcone(
                icone: Icons.computer_outlined,
                textoIcone: 'COMPUTADOR',
                corDeFundo: const Color(0xFF8d40b7),
                onPressed: () {
                  Navigator.pushNamed(context, '/BluetoothPage');
                },
              ),
              BotaoComIcone(
                  icone: Icons.sports_esports,
                  textoIcone: 'CONTROLE',
                  corDeFundo: const Color.fromARGB(255, 78, 78, 78),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ControlePage');
                  }),
              BotaoComIcone(
                  icone: Icons.build,
                  textoIcone: 'MANUTENÇÃO',
                  corDeFundo: const Color(0xFFd5ac4d),
                  onPressed: () {
                    Navigator.pushNamed(context, '/BluetoothPage');
                  }),
              BotaoComIcone(
                  icone: Icons.list,
                  textoIcone: 'ROTINAS',
                  corDeFundo: const Color(0xFFd57171),
                  onPressed: () {
                    Navigator.pushNamed(context, '/BluetoothPage');
                  }),
              BotaoComIcone(
                  icone: Icons.radar,
                  textoIcone: 'SENSORES',
                  corDeFundo: const Color(0xFF9ac847),
                  onPressed: () {
                    Navigator.pushNamed(context, '/BluetoothPage');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
