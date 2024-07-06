import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../buttons/button_icon.dart';
import '../screens/bluetooth.dart';

void main() {
  runApp(const homePage());
}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/bluetoothpage': (context) => const bluetoothPage(),
      },
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
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
              botaoComIcone(
                icone: Icons.bluetooth,
                textoIcone: 'BLUETOOTH',
                corDeFundo: Color(0xFF7171d5),
                onPressed: () {
                  Navigator.pushNamed(context, '/bluetoothpage');
                },
              ),
              botaoComIcone(
                icone: Icons.computer_outlined,
                textoIcone: 'COMPUTADOR',
                corDeFundo: Color(0xFF8d40b7),
                onPressed: () {
                  Navigator.pushNamed(context, '/bluetoothpage');
                },
              ),
              botaoComIcone(
                  icone: Icons.sports_esports,
                  textoIcone: 'CONTROLE',
                  corDeFundo: Color(0xFF42b7ac),
                  onPressed: () {
                    Navigator.pushNamed(context, '/bluetoothpage');
                  }),
              botaoComIcone(
                  icone: Icons.build,
                  textoIcone: 'MANUTENÇÃO',
                  corDeFundo: Color(0xFFd5ac4d),
                  onPressed: () {
                    Navigator.pushNamed(context, '/bluetoothpage');
                  }),
              botaoComIcone(
                  icone: Icons.list,
                  textoIcone: 'ROTINAS',
                  corDeFundo: Color(0xFFd57171),
                  onPressed: () {
                    Navigator.pushNamed(context, '/bluetoothpage');
                  }),
              botaoComIcone(
                  icone: Icons.radar,
                  textoIcone: 'SENSORES',
                  corDeFundo: Color(0xFF9ac847),
                  onPressed: () {
                    Navigator.pushNamed(context, '/bluetoothpage');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
