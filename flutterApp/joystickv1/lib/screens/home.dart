import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../buttons/button_icon.dart';

void main() {
  runApp(bluetoothPage());
}

class bluetoothPage extends StatefulWidget {
  bluetoothPage({Key? key}) : super(key: key);

  @override
  _bluetoothPageState createState() => _bluetoothPageState();
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
              botaoComIcone(
                  icone: Icons.bluetooth,
                  textoIcone: 'BLUETOOTH',
                  corDeFundo: Colors.blue,
                  onPressed: () {
                    print('ola');
                  }),
              botaoComIcone(
                  icone: Icons.account_balance_rounded,
                  textoIcone: 'OLá teste 4',
                  corDeFundo: Colors.red,
                  onPressed: () {
                    print('teste 4');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
