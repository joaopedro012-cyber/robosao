import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('JoystickLogger'); // Configurando o logger

class ControlePage extends StatefulWidget {
  const ControlePage({super.key, required List<String> connectedDevices});

  @override
  ControlePageState createState() => ControlePageState();
}

class ControlePageState extends State<ControlePage> {
  String? _selectedRoutine; // Variável para armazenar o valor selecionado no dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
      ),
      body: Container(
        color: const Color(0xFFECE6F0),  // Cor de fundo alterada para #ECE6F0
        child: Stack(
          children: [
            // Joysticks e conteúdo de fundo
            const Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: JoystickVertical(),  // Joystick para cima e para baixo
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: JoystickHorizontal(),  // Joystick para esquerda e direita
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Dropdown sobreposto em uma posição específica
            Positioned(
              top: 20, // Posição ajustada conforme necessário
              right: 16, // Posição ajustada conforme necessário
              child: SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Selecione uma rotina',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRoutine,
                  items: <String>['Rotina 1', 'Rotina 2', 'Rotina 3', 'Rotina 4'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRoutine = newValue;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para o joystick vertical (cima e baixo)
class JoystickVertical extends StatefulWidget {
  const JoystickVertical({super.key});

  @override
  JoystickVerticalState createState() => JoystickVerticalState();
}

class JoystickVerticalState extends State<JoystickVertical> {
  double _yOffset = 0.0;
  bool wPressionado = false;
  bool sPressionado = false;
  double wContador = 0;
  double sContador = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _yOffset += details.delta.dy;
                  // Limite de movimento
                  if (_yOffset > 50) _yOffset = 50;
                  if (_yOffset < -50) _yOffset = -50;

                  // Verifica a direção do movimento vertical
                  if (_yOffset < 0) {
                    if (!wPressionado) {
                      wPressionado = true;
                      sPressionado = false;
                      log.info('w');  // Movimentação para cima
                    }
                    incrementaContador('w');
                  } else if (_yOffset > 0) {
                    if (!sPressionado) {
                      sPressionado = true;
                      wPressionado = false;
                      log.info('x');  // Movimentação para baixo
                    }
                    incrementaContador('x');
                  } else {
                    if (wPressionado) {
                      wPressionado = false;
                      _insertExecucaoRotina('w', wContador);
                      wContador = 0;
                    }
                    if (sPressionado) {
                      sPressionado = false;
                      _insertExecucaoRotina('x', sContador);
                      sContador = 0;
                    }
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _yOffset = 0;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF65558F),  // Cor do botão alterada para #65558F
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, _yOffset),
                    child: const Icon(Icons.circle, color: Colors.white, size: 24),  // Substitui texto por bolinha
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void incrementaContador(String direcao) {
    if (direcao == 'w') {
      wContador++;
    } else if (direcao == 's') {
      sContador++;
    }
  }

  void _insertExecucaoRotina(String direcao, double contador) {
    // Implemente a lógica para inserir execução da rotina com base na direção e contador
    log.info('Executando rotina para $direcao com contador $contador');
  }
}

// Widget para o joystick horizontal (esquerda e direita)
class JoystickHorizontal extends StatefulWidget {
  const JoystickHorizontal({super.key});

  @override
  JoystickHorizontalState createState() => JoystickHorizontalState();
}

class JoystickHorizontalState extends State<JoystickHorizontal> {
  double _xOffset = 0.0;
  bool aPressionado = false;
  bool dPressionado = false;
  double aContador = 0;
  double dContador = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _xOffset += details.delta.dx;
                  // Limite de movimento
                  if (_xOffset > 50) _xOffset = 50;
                  if (_xOffset < -50) _xOffset = -50;

                  // Verifica a direção do movimento horizontal
                  if (_xOffset < 0) {
                    if (!aPressionado) {
                      aPressionado = true;
                      dPressionado = false;
                      log.info('a');  // Movimentação para esquerda
                    }
                    incrementaContador('a');
                  } else if (_xOffset > 0) {
                    if (!dPressionado) {
                      dPressionado = true;
                      aPressionado = false;
                      log.info('d');  // Movimentação para direita
                    }
                    incrementaContador('d');
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
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _xOffset = 0;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF65558F),  // Cor do botão alterada para #65558F
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(_xOffset, 0),
                    child: const Icon(Icons.circle, color: Colors.white, size: 24),  // Substitui texto por bolinha
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void incrementaContador(String direcao) {
    if (direcao == 'a') {
      aContador++;
    } else if (direcao == 'd') {
      dContador++;
    }
  }

  void _insertExecucaoRotina(String direcao, double contador) {
    // Implemente a lógica para inserir execução da rotina com base na direção e contador
    log.info('Executando rotina para $direcao com contador $contador');
  }
}
