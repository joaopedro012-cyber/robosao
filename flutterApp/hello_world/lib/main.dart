import 'package:flutter/material.dart';

void main() {
  runApp(MyApp2(nome: 'Pedro'));
}

class MyApp2 extends StatefulWidget {
  final String nome;
  MyApp2({Key? key, this.nome = ''}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  int salario = 1237000;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Olá O salário de ${widget.nome} é $salario',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
