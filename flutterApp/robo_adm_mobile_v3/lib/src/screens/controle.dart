import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:robo_adm_mobile_v2/src/database/db.dart';
import 'dart:typed_data';
import 'dart:convert';

final log = Logger('JoystickLogger');

class ControlePage extends StatefulWidget {
  final List<BluetoothDevice> connectedDevices;
  final List<BluetoothConnection> connections;

  const ControlePage({super.key, required this.connectedDevices, required this.connections});

  @override
  ControlePageState createState() => ControlePageState();
}

class ControlePageState extends State<ControlePage> {
  String? _selectedRoutine;
  final DB _db = DB.instance;
  double _currentSliderValue = 50;
  List<Map<String, dynamic>> _rotinas = [];
  final List<bool> _tomadaSelecionada = [false, false, false];

  @override
  void initState() {
    super.initState();
    _loadRotinas(); // Carrega as rotinas ao iniciar
  }

  Future<void> _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    setState(() {
      _rotinas = rotinas; // Atualiza a lista de rotinas
    });
  }

  void sendBluetoothCommand(String command) {
    for (var connection in widget.connections) {
      List<int> bytes = utf8.encode(command); // Converte o comando em bytes
      connection.output.add(Uint8List.fromList(bytes)); // Envia o comando
      log.info('Comando enviado: $command');
    }
  }

  Future<void> registerActionAndSendCommand({
    required String actionDescription,
    required int quantidade,
    required String bluetoothCommand,
  }) async {
    if (_selectedRoutine != null) {
      try {
        await _db.insertAcao(
          idRotina: int.parse(_selectedRoutine!),
          acaoHorizontal: actionDescription,
          qtdHorizontal: quantidade,
          acaoVertical: '',
          qtdVertical: 0,
          acaoPlataforma: '',
          qtdPlataforma: 0,
          acaoBotao1: '',
          qtdBotao1: 0,
          acaoBotao2: '',
          qtdBotao2: 0,
          acaoBotao3: '',
          qtdBotao3: 0,
          dtExecucao: DateTime.now().millisecondsSinceEpoch,
        );
        log.info('Ação do robô registrada com sucesso: $actionDescription');
        sendBluetoothCommand(bluetoothCommand);
      } catch (e) {
        log.severe('Erro ao registrar ação do robô: $e');
      }
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  void turnOnDevice(int deviceNumber) async {
    log.info('Ligando a tomada $deviceNumber');
    await registerActionAndSendCommand(
      actionDescription: 'Ligar Tomada $deviceNumber',
      quantidade: 0,
      bluetoothCommand: 'Ligar Tomada $deviceNumber',
    );
  }

  void turnOffDevice(int deviceNumber) async {
    log.info('Desligando a tomada $deviceNumber');
    await registerActionAndSendCommand(
      actionDescription: 'Desligar Tomada $deviceNumber',
      quantidade: 0,
      bluetoothCommand: 'Desligar Tomada $deviceNumber',
    );
  }

  void movePlatform(double position) async {
    log.info('Movendo a plataforma para: $position');
    await registerActionAndSendCommand(
      actionDescription: 'Movendo Plataforma para ${position * 100}%',
      quantidade: (position * 100).toInt(),
      bluetoothCommand: 'Movendo Plataforma para ${position * 100}%',
    );
  }

  void moveRobot(double horizontal, double vertical) async {
    if (_selectedRoutine != null) {
      int pulseCount = 0;
      String command = '';

      if (horizontal > 0) {
        pulseCount = (horizontal * 100).toInt();
        command = 'MOVE_RIGHT:$pulseCount';
      } else if (horizontal < 0) {
        pulseCount = (-horizontal * 100).toInt();
        command = 'MOVE_LEFT:$pulseCount';
      }

      if (vertical > 0) {
        pulseCount = (vertical * 100).toInt();
        command = 'MOVE_FORWARD:$pulseCount';
      } else if (vertical < 0) {
        pulseCount = (-vertical * 100).toInt();
        command = 'MOVE_BACKWARD:$pulseCount';
      }

      log.info('Movendo o robô - Comando: $command');
      await registerActionAndSendCommand(
        actionDescription: command,
        quantidade: pulseCount,
        bluetoothCommand: command,
      );
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),  // Espaçamento da borda direita
            child: SizedBox(
              width: 200,  // Largura do Dropdown
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione uma rotina',
                  border: OutlineInputBorder(),
                ),
                value: _selectedRoutine,
                items: _rotinas.map((rotina) {
                  return DropdownMenuItem<String>(
                    value: rotina['ID_ROTINA'].toString(),
                    child: Text(rotina['NOME']),
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
      body: Container(
        color: const Color(0xFFECE6F0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container para o joystick esquerdo
                    SizedBox(
                      width: tamanhoTela * 0.17,
                      height: tamanhoTela * 0.17,
                      child: JoystickHorizontal(
                        moveRobot: (double horizontal) {
                          moveRobot(horizontal, 0); // Motor horizontal
                        },
                      ),
                    ),
                    // Container para o slider
                    RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        width: tamanhoTela * 0.40,
                        child: Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                            movePlatform(value / 100); // Mova a plataforma conforme o slider
                          },
                        ),
                      ),
                    ),
                    // Container para os botões de controle
                    SizedBox(
                      width: tamanhoTela * 0.30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTomadaButton(1),
                          const SizedBox(height: 8),
                          _buildTomadaButton(2),
                          const SizedBox(height: 8),
                          _buildTomadaButton(3),
                        ],
                      ),
                    ),
                    // Container para o joystick direito
                    SizedBox(
                      width: tamanhoTela * 0.17,
                      height: tamanhoTela * 0.17,
                      child: JoystickVertical(
                        moveRobot: (double vertical) {
                          moveRobot(0, vertical);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTomadaButton(int deviceNumber) {
    bool isSelected = _tomadaSelecionada[deviceNumber - 1];

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (isSelected) {
              return const Color(0xFFE6E0E9);
            }
            return const Color.fromARGB(255, 84, 1, 100);
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (isSelected) {
              return Colors.purple;
            }
            return Colors.white;
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
          return const BorderSide(color: Color.fromARGB(255, 30, 30, 30), width: 2);
        }),
      ),
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
          _tomadaSelecionada[deviceNumber - 1] = isSelected;

          if (isSelected) {
            turnOnDevice(deviceNumber);
          } else {
            turnOffDevice(deviceNumber);
          }
        });
      },
      child: Text('Tomada $deviceNumber'),
    );
  }
}




class JoystickHorizontal extends StatefulWidget {
  final Function(double) moveRobot;

  const JoystickHorizontal({super.key, required this.moveRobot});

  @override
  JoystickHorizontalState createState() => JoystickHorizontalState();
}

class JoystickHorizontalState extends State<JoystickHorizontal> {
  double _yOffset = 0.0; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _yOffset += details.delta.dy; 

          if (_yOffset > 40) _yOffset = 40;
          if (_yOffset < -40) _yOffset = -40;

          widget.moveRobot(_yOffset / 40);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _yOffset = 0;
        });
        widget.moveRobot(0);
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF65558F),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Transform.translate(
              offset: Offset(0, _yOffset),
              child: const Icon(Icons.circle, size: 48, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


class JoystickVertical extends StatefulWidget {
  final Function(double) moveRobot;

  const JoystickVertical({super.key, required this.moveRobot});

  @override
  JoystickVerticalState createState() => JoystickVerticalState();
}

class JoystickVerticalState extends State<JoystickVertical> {
  double _xOffset = 0.0; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _xOffset += details.delta.dx; 

          if (_xOffset > 40) _xOffset = 40;
          if (_xOffset < -40) _xOffset = -40;

          widget.moveRobot(_xOffset / 40);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _xOffset = 0;
        });
        widget.moveRobot(0);
      },
      child: Container(
        width: 50,
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF65558F),
          shape: BoxShape.circle,  
        ),
        child: Center(
          child: Transform.translate(
            offset: Offset(_xOffset, 0), 
            child: const Icon(Icons.circle, size: 48, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
