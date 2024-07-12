import 'package:flutter/material.dart';
import 'package:roboadmv1/screens/bluetooth/home/home.dart';
import 'package:roboadmv1/screens/controle/controle.dart';
import '../buttons/button_icon.dart';
import 'package:roboadmv1/main.dart';

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
              BotaoComIcone(
                icone: Icons.bluetooth,
                textoIcone: 'BLUETOOTH',
                corDeFundo: Color(0xFF7171d5),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BluetoothPage(),
                    ),
                  );
                },
              ),
              BotaoComIcone(
                icone: Icons.computer_outlined,
                textoIcone: 'COMPUTADOR',
                corDeFundo: Color(0xFF8d40b7),
                onPressed: () {
                  Navigator.pushNamed(context, '/BluetoothPage');
                },
              ),
              BotaoComIcone(
                  icone: Icons.sports_esports,
                  textoIcone: 'CONTROLE',
                  corDeFundo: Color.fromARGB(255, 78, 78, 78),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ControlePage(),
                      ),
                    );
                  }),
              BotaoComIcone(
                  icone: Icons.build,
                  textoIcone: 'MANUTENÇÃO',
                  corDeFundo: Color(0xFFd5ac4d),
                  onPressed: () {
                    Navigator.pushNamed(context, '/BluetoothPage');
                  }),
              BotaoComIcone(
                  icone: Icons.list,
                  textoIcone: 'ROTINAS',
                  corDeFundo: Color(0xFFd57171),
                  onPressed: () {
                    Navigator.pushNamed(context, '/BluetoothPage');
                  }),
              BotaoComIcone(
                  icone: Icons.radar,
                  textoIcone: 'SENSORES',
                  corDeFundo: Color(0xFF9ac847),
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
