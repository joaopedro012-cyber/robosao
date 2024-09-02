import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ControlePage());
}

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

Future<List<Map<String, dynamic>>> _getRotinas() async {
  final db = await DB.instance.database;
  return await db.query('ADM_ROTINAS', columns: ['ID_ROTINA', 'NOME']);
}

class _ControlePageState extends State<ControlePage> {
  int wContador = 0;
  int xContador = 0;
  int aContador = 0;
  int dContador = 0;
  bool wPressionado = false;
  bool xPressionado = false;
  bool aPressionado = false;
  bool dPressionado = false;
  late Future<List<Map<String, dynamic>>> _rotinasFuture;
  int? _selectedRotinaId;

  @override
  void initState() {
    super.initState();
    _rotinasFuture = _getRotinas();
  }

  void incrementaContador(String btnPressionado) {
    setState(() {
      switch (btnPressionado) {
        case 'w':
          if (wPressionado) {
            wContador++;
            if (kDebugMode) {
              print("w contador é $wContador");
            }
          }
          break;
        case 'x':
          if (xPressionado) {
            xContador++;
            if (kDebugMode) {
              print("x contador é $xContador");
            }
          }
          break;
        case 'a':
          if (aPressionado) {
            aContador++;
            if (kDebugMode) {
              print("a contador é $aContador");
            }
          }
          break;
        case 'd':
          if (dPressionado) {
            dContador++;
            if (kDebugMode) {
              print("d contador é $dContador");
            }
          }
          break;
      }
    });
  }

  void resetarContadores(String contadorParaReset) {
    setState(() {
      switch (contadorParaReset) {
        case 'w':
          wContador = 0;
          break;
        case 'x':
          xContador = 0;
          break;
        case 'a':
          aContador = 0;
          break;
        case 'd':
          dContador = 0;
          break;
      }
    });
  }

  Future<void> _insertExecucaoRotina(String acao, int qtdSinais) async {
    if (_selectedRotinaId != null) {
      await DB.insertExecucaoRotina(_selectedRotinaId!, acao, qtdSinais);
    } else {
      if (kDebugMode) {
        print("ID da rotina não selecionado.");
      }
    }
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
                    Container(
                      width: larguraAlturaJoystick,
                      height: 75,
                      color: Colors.green,
                    ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Joystick Cima e Baixo
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
                            double valorHorizontal = details.x;

                            if (valorVertical > 0.000000000000001) {
                              wPressionado = false;
                              xPressionado = true;
                              incrementaContador('x');
                            } else if (valorVertical < -0.000000000000001) {
                              xPressionado = false;
                              wPressionado = true;
                              incrementaContador('w');
                            } else {
                              if (wPressionado) {
                                wPressionado = false;
                                _insertExecucaoRotina('w', wContador);
                                wContador = 0;
                              }

                              if (xPressionado) {
                                xPressionado = false;
                                _insertExecucaoRotina('x', xContador);
                                xContador = 0;
                              }
                            }

                            if (valorHorizontal > 0.000000000000001) {
                              dPressionado = true;
                              aPressionado = false;
                              incrementaContador('d');
                            } else if (valorHorizontal < -0.000000000000001) {
                              aPressionado = true;
                              dPressionado = false;
                              incrementaContador('a');
                            } else {
                              if (dPressionado) {
                                dPressionado = false;
                                _insertExecucaoRotina('d', dContador);
                                dContador = 0;
                              }

                              if (aPressionado) {
                                aPressionado = false;
                                _insertExecucaoRotina('a', aContador);
                                aContador = 0;
                              }
                            }

                            if (kDebugMode) {
                              print(
                                  "Valor Vertical: $valorVertical, wPressionado: $wPressionado, xPressionado: $xPressionado");
                            }
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: larguraAlturaJoystick,
                          color: Colors.yellow,
                        ),
                        Container(
                          width: 150,
                          height: larguraAlturaJoystick,
                          color: Colors.pink,
                        ),
                      ],
                    ),
                    // Joystick esquerda e direita
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

                            if (valorHorizontal > 0.000000000000001) {
                              aPressionado = false;
                              dPressionado = true;
                              incrementaContador('d');
                            } else if (valorHorizontal < -0.000000000000001) {
                              dPressionado = false;
                              aPressionado = true;
                              incrementaContador('a');
                            } else {
                              if (aPressionado) {
                                aPressionado = false;
                                _insertExecucaoRotina('a', aContador);
                                aContador = 0;
                              }

                              if (dPressionado) {
                                dPressionado = false;
                                _insertExecucaoRotina('d', dContador);
                                dContador = 0;
                              }
                            }

                            if (kDebugMode) {
                              print(
                                  "Valor Horizontal: $valorHorizontal, aPressionado: $aPressionado, dPressionado: $dPressionado");
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
