import 'package:flutter/material.dart';
import '../buttons/button_icon.dart';

void main() {
  runApp(const MaterialApp(
    home: bluetoothPage(),
  ));
}

class bluetoothPage extends StatefulWidget {
  const bluetoothPage({Key? key}) : super(key: key);

  @override
  _bluetoothPageState createState() => _bluetoothPageState();
}

class _bluetoothPageState extends State<bluetoothPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF7171d5),
          title: Text(
            'Conexões Bluetooth',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
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
