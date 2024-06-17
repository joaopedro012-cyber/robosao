import 'package:flutter/material.dart';

void main() {
  runApp(MyApp5());
}

class MyApp5 extends StatelessWidget {
  const MyApp5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Administração do Robo'),
          ),
          body: Stack(children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.blue,
            ),
            Positioned(
              right: -50,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            ),
          ])),
    );
  }
}
