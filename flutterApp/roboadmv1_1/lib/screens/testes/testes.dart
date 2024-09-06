import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1_1/screens/home.dart';
import 'package:roboadmv1_1/database/db.dart';
//import 'package:roboadmv1_1/screens/bluetooth/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const TestesPage());
}

Future<List<Map<String, dynamic>>> _getRotinas() async {
  final db = await DB.instance.database;
  return await db.query('ADM_ROTINAS', columns: ['ID_ROTINA', 'NOME']);
}


class TestesPage extends StatefulWidget {
  const TestesPage({super.key});

  @override
  State<TestesPage> createState() => _TestesPageState();
}

class _TestesPageState extends State<TestesPage> {
  late Future<List<Map<String, dynamic>>> _rotinasFuture;
  int? _selectedRotinaId;

  @override
  void initState() {
    super.initState();
    _rotinasFuture = _getRotinas();
  }

  @override
  Widget build(BuildContext context) {
    const JoystickMode joystickModeHorizontal = JoystickMode.horizontal;
    const JoystickMode joystickModeVertical = JoystickMode.vertical;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerLarguraPadrao = screenWidth * 0.98;
    double larguraAlturaJoystick = screenWidth * 0.20;
    double containerInferior = screenHeight * 0.55;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Controle'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          actions: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _rotinasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma rotina disponível'));
                } else {
                  final rotinas = snapshot.data!;
                  return DropdownButton<int>(
                    value: _selectedRotinaId,
                    hint: const Text('Selecione uma rotina'),
                    items: rotinas.map((rotina) {
                      return DropdownMenuItem<int>(
                        value: rotina['ID_ROTINA'],
                        child: Text(rotina['NOME']),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedRotinaId = newValue;
                      });
                    },
                  );
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: containerLarguraPadrao,
                height: 75,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //TELA
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.green,
                    ),
                    //DADOS EM TEMPO REAL
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: containerLarguraPadrao,
                height: containerInferior,
                //color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Joystick Cima e Baixo
                    Container(
                      width: larguraAlturaJoystick,
                      height: larguraAlturaJoystick,
                      color: Colors.white54,
                      child: Joystick(
                        mode: joystickModeVertical,
                        includeInitialAnimation: false,
                        stick: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                        ),
                        listener: (details) {
                          setState(() {
                            double valorVertical = details.y;

                            switch (valorVertical) {
                              case >= 0.000000000000001:
                                //widget.connection1.writeString("x");
                                if (kDebugMode) {
                                  print(
                                      //  "Valor de Y: é positivo $valorVertical"
                                      "x");
                                }
                                break;
                              case <= -0.000000000000001:
                                //widget.connection1.writeString("w");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de Y: é negativo $valorVertical"
                                      "w");
                                }
                            }
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Plataforma
                        Container(
                          width: 50,
                          height: larguraAlturaJoystick,
                          color: Colors.yellow,
                        ),
                        //Tomadas
                        Container(
                          width: 150,
                          height: larguraAlturaJoystick,
                          color: Colors.pink,
                        ),
                      ],
                    ),
                    //Joystick esquerda e direita
                    Container(
                      width: larguraAlturaJoystick,
                      height: larguraAlturaJoystick,
                      color: Colors.white,
                      child: Joystick(
                        mode: joystickModeHorizontal,
                        includeInitialAnimation: false,
                        stick: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                        ),
                        listener: (details) {
                          setState(() {
                            double valorHorizontal = details.x;

                            switch (valorHorizontal) {
                              case >= 0.000000000000001:
                                // widget.connection2.writeString("d");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de X: é positivo $valorHorizontal"
                                      "d");
                                }
                                break;
                              case <= -0.000000000000001:
                                //  widget.connection2.writeString("a");
                                if (kDebugMode) {
                                  print(
                                      //"Valor de X: é negativo $valorHorizontal"
                                      "a");
                                }
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

