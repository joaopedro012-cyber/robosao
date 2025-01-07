import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:robo_adm_mobile_v2/src/database/db.dart';
import 'dart:convert';
import 'package:robo_adm_mobile_v2/src/screens/bluetooth.dart'; 

final log = Logger('JoystickLogger');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle do Robô',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ControlePage(
        connectedDevices: [],
        connections: [],
      ),
    );
  }
}

class ControlePage extends StatefulWidget {
  final List<BluetoothDevice> connectedDevices;
  final List<BluetoothConnection> connections;

  const ControlePage({super.key, required this.connectedDevices, required this.connections});

  @override
  ControlePageState createState() => ControlePageState();
}

class SendBD {
  static String acaoHorizontal = '';
  static int qtdHorizontal = 0;
  static String acaoVertical = '';
  static int qtdVertical = 0;
  static String acaoBotao1 = '';
  static int qtdBotao1 = 0;
  static String acaoBotao2 = '';
  static int qtdBotao2 = 0;
  static String acaoPlataforma = '';
  static String qtdPlataforma = ''; 
}

class ControlePageState extends State<ControlePage> {
  String? selectedRoutine;
  final DB db = DB.instance;
  String comandoPlataforma = '';
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

  DateTime? _lastVerticalCommandTime;

  Future<void> sendBluetoothCommand(String command) async {
    final now = DateTime.now();

    if (['a', 'd', 'z'].contains(command)) {
      if (_lastVerticalCommandTime != null &&
          now.difference(_lastVerticalCommandTime!).inSeconds < 1) {
        log.info('Comando "$command" ignorado. Aguardando intervalo de 1 segundo (motor vertical).');
        return;
      }

      _lastVerticalCommandTime = now;

      for (var connection in widget.connections) {
        String address = connection.address;
        if (address == BluetoothManager.macVertical) {
          List<int> bytes = utf8.encode(command);
          connection.output.add(Uint8List.fromList(bytes));
          await Future.delayed(const Duration(milliseconds: 100));
          log.info('Comando "$command" enviado para o módulo Vertical ($address)');
          await connection.output.allSent;
        } else {
          log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Vertical: $address');
        }
      }
      return;
    }

    if (['w', 'x', 's'].contains(command)) {
      for (var connection in widget.connections) {
        String address = connection.address;

        if (address == BluetoothManager.macHorizontal ) {
          List<int> bytes = utf8.encode(command);
          connection.output.add(Uint8List.fromList(bytes));
          await Future.delayed(const Duration(milliseconds: 100));
          log.info('Comando "$command" enviado para o módulo Horizontal ($address)');
          await connection.output.allSent;
        } else {
          log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Horizontal: $address');
        }
      }
    } else {
      log.warning('Comando "$command" inválido e não enviado.');
    }

    if (command.contains('Movendo Plataforma')) {
      for (var connection in widget.connections) {
        String address = connection.address;
        if (('Movendo Plataforma: b').contains(command)) {
          if (address == BluetoothManager.macPlataforma) {
            List<int> bytes = utf8.encode('b');
            connection.output.add(Uint8List.fromList(bytes));
            await Future.delayed(const Duration(milliseconds: 100));
            log.info('Comando "$command" enviado para o módulo Plataforma ($address)');
            await connection.output.allSent;
          } else {
            log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Plataforma: $address');
          }
        } else if (('Movendo Plataforma: c').contains(command)) {
          if (address == BluetoothManager.macPlataforma) {
            List<int> bytes = utf8.encode('c');
            connection.output.add(Uint8List.fromList(bytes));
            await Future.delayed(const Duration(milliseconds: 100));
            log.info('Comando "$command" enviado para o módulo Plataforma ($address)');
            await connection.output.allSent;
          } else {
            log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Plataforma: $address');
          }
        }  
      }
    } else {
      log.warning('Comando "$command" inválido e não enviado.');
    } if (command.contains('Ligar Tomada')) {
      for (var connection in widget.connections) {
        String address = connection.address;
        if (address == BluetoothManager.macTomadas) {
          List<int> bytes = utf8.encode(command);
          connection.output.add(Uint8List.fromList(bytes));
          await Future.delayed(const Duration(milliseconds: 100));
          log.info('Comando "$command" enviado para o módulo Plataforma ($address)');
          await connection.output.allSent;
        } else {
          log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Plataforma: $address');
        }
      }
    } else {
      log.warning('Comando "$command" inválido e não enviado.');
    } if (command.contains('Desligar Tomada')) {
      for (var connection in widget.connections) {
        String address = connection.address;

        if (address == BluetoothManager.macTomadas) {
          List<int> bytes = utf8.encode(command);
          connection.output.add(Uint8List.fromList(bytes));
          await Future.delayed(const Duration(milliseconds: 100));
          log.info('Comando "$command" enviado para o módulo Plataforma ($address)');
          await connection.output.allSent;
        } else {
          log.warning('Comando "$command" ignorado. Endereço MAC incorreto para Plataforma: $address');
        }
      }
    } else {
      log.warning('Comando "$command" inválido e não enviado.');
    } 
  }

  Future<void> registerActionAndSendCommand({
    required String actionDescription,
    required int quantidade,
    required String bluetoothCommand,
  }) async {
    if (selectedRoutine != null && actionDescription.isNotEmpty) {
      try {
        String acaoHorizontal = '';
        int qtdHorizontal = 0;
        String acaoVertical = '';
        int qtdVertical = 0;
        String acaoBotao1 = '';
        int qtdBotao1 = 0;
        String acaoBotao2 = '';
        int qtdBotao2 = 0;
        String acaoPlataforma = '';
        String qtdPlataforma = '';

        if (actionDescription.contains('Motor')) {
          if (actionDescription.contains('Motor movendo para trás: x')) {
            SendBD.acaoHorizontal = 'x';
            SendBD.qtdHorizontal = quantidade; 
          } else if (actionDescription.contains('Motor movendo para frente: w')) {
            SendBD.acaoHorizontal = 'w';
            SendBD.qtdHorizontal = quantidade;
          } else if (actionDescription.contains('Motor Horizontal desligado')) {
            SendBD.acaoHorizontal = 's';
            SendBD.qtdHorizontal = quantidade;
          } else if (actionDescription.contains('Motor virando para direita: d')) {
            SendBD.acaoVertical = 'd';
            SendBD.qtdVertical = quantidade;
          } else if (actionDescription.contains('Motor virando para esquerda: a')) {
            SendBD.acaoVertical = 'a';
            SendBD.qtdVertical = quantidade;
          } 
        } else if (actionDescription.contains('Desligar Tomada')) {
          if (actionDescription.contains('Desligar Tomada 1')) {
            SendBD.acaoBotao1 = actionDescription ;
            SendBD.qtdBotao1 = quantidade;
            sendBluetoothCommand('Desligar Tomada 1');
          } else if (actionDescription.contains('Desligar Tomada 2')) {
            SendBD.acaoBotao2 = actionDescription;
            SendBD.qtdBotao2 = quantidade;
            sendBluetoothCommand('Desligar Tomada 2');
          }
        } else if (actionDescription.contains('Ligar Tomada')) {
          if (actionDescription.contains('Ligar Tomada 1')) {
            SendBD.acaoBotao1 = actionDescription;
            SendBD.qtdBotao1 = quantidade;
            sendBluetoothCommand('Ligar Tomada 1');
          } else if (actionDescription.contains('Ligar Tomada 2')) {
            SendBD.acaoBotao2 = actionDescription;
            SendBD.qtdBotao2 = quantidade;
            sendBluetoothCommand('Ligar Tomada 2');
          }
        } else if (actionDescription.contains('Movendo Plataforma: ')) {
          if (actionDescription.contains('Movendo Plataforma: c')) {
            SendBD.acaoPlataforma = actionDescription;
            SendBD.qtdPlataforma = 'c';
            sendBluetoothCommand('Movendo Plataforma: c');
          } else if (actionDescription.contains('Movendo Plataforma: b')) {
            SendBD.acaoPlataforma = actionDescription;
            SendBD.qtdPlataforma = 'b'; 
            sendBluetoothCommand('Movendo Plataforma: b');
          }
        }

        await db.insertAcao(
          idRotina: int.parse(selectedRoutine!),
          acaoHorizontal: acaoHorizontal,
          qtdHorizontal: qtdHorizontal,
          acaoVertical: acaoVertical,
          qtdVertical: qtdVertical,
          acaoPlataforma: acaoPlataforma,
          qtdPlataforma: qtdPlataforma,
          acaoBotao1: acaoBotao1,
          qtdBotao1: qtdBotao1,
          acaoBotao2: acaoBotao2,
          qtdBotao2: qtdBotao2,
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
      log.warning('Nenhuma rotina selecionada ou descrição de ação vazia.');
    }
  }

  void turnOnDevice(int deviceNumber) async {
    log.info('Ligando a tomada $deviceNumber');
    await registerActionAndSendCommand(
      actionDescription: 'Ligar Tomada $deviceNumber',
      quantidade: 0,
      bluetoothCommand: 'Ligar Tomada $deviceNumber'
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

  void movePlatform(String comandoPlataforma) async {
    if (comandoPlataforma == 'c') {
      log.info('Movendo a plataforma para C');
      await registerActionAndSendCommand(
      actionDescription: 'Movendo Plataforma: c',
      quantidade: 0,
      bluetoothCommand: 'Movendo Plataforma: c',
    );
    } else if (comandoPlataforma == 'b') {
      log.info('Movendo a plataforma para B');
     await registerActionAndSendCommand(
      actionDescription: 'Movendo Plataforma: b',
      quantidade: 0,
      bluetoothCommand: 'Movendo Plataforma: b',
    );
    }
  }

  void _sendMovementCommand(String command) {
    if (kDebugMode) {
      print('Comando enviado: $command');
    }
    sendBluetoothCommand(command);
  }

  void moveRobot(double horizontal, double vertical) async {
    if (selectedRoutine != null) {
      if (horizontal < 0) {
        _sendMovementCommand('w'); // Para frente
        log.info('Motor movendo para frente: w');
      } else if (horizontal > 0) { 
        _sendMovementCommand('x'); // Para trás
        log.info('Motor movendo para trás: x');
      } else if (horizontal == 0) {
        _sendMovementCommand('s');
        log.info('Motor Horizontal desligado');
      }

      if (vertical < 0) {
        _sendMovementCommand('a'); // Para esquerda
        log.info('Motor virando para esquerda: a');
      } else if (vertical > 0) {
        _sendMovementCommand('d'); // Para direita
        log.info('Motor virando para direita: d');
      }
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;

    String? descricaoRotinaSelecionada;
    if (selectedRoutine != null) {
      final rotina = _rotinas.firstWhere(
        (r) => r['id_rotina'].toString() == selectedRoutine,
        orElse: () => {},  
      );
      descricaoRotinaSelecionada = rotina.isNotEmpty ? rotina['descricao'] as String? : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Controle',
          style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        toolbarHeight: 70.0,
      ),
      body: Container(
        color: const Color(0xFFECE6F0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Selecione uma rotina',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRoutine,
                    items: _rotinas.map((rotina) {
                      return DropdownMenuItem<String>(
                        value: rotina['id_rotina'].toString(),
                        child: Text(rotina['nome']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRoutine = newValue;
                      });
                    },
                  ),
                  if (descricaoRotinaSelecionada != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        descricaoRotinaSelecionada,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: tamanhoTela * 0.17,
                      height: tamanhoTela * 0.17,
                      child: JoystickHorizontal(
                        moveRobot: (double horizontal) {
                          moveRobot(horizontal, 0); // Motor horizontal
                        },
                      ),
                    ),
                    SizedBox(
                      width: tamanhoTela * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              comandoPlataforma = 'c';
                              log.info('Comando enviado para subir: $comandoPlataforma');
                              movePlatform(comandoPlataforma);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(40, 40), 
                              padding: EdgeInsets.zero, 
                            ),
                            child: const Text('+', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              comandoPlataforma = 'b';
                              log.info('Comando enviado para descer: $comandoPlataforma');
                              movePlatform(comandoPlataforma);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(40, 40),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('-', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: tamanhoTela * 0.25,
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
                    SizedBox(
                      width: tamanhoTela * 0.17,
                      height: tamanhoTela * 0.17,
                      child: JoystickVertical(
                        moveRobot: (double vertical) {
                          moveRobot(0, vertical); // Motor vertical
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
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (isSelected) {
            return const Color(0xFFE6E0E9);
          }
          return const Color.fromARGB(255, 84, 1, 100);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (isSelected) {
            return Colors.purple;
          }
          return Colors.white;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: Color.fromARGB(255, 111, 43, 131), width: 2),
        ),
        minimumSize: WidgetStateProperty.all(const Size(110, 40)),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
        setState(() {
          _tomadaSelecionada[deviceNumber - 1] = !isSelected;
        });
        if (isSelected) {
          turnOffDevice(deviceNumber);
        } else {
          turnOnDevice(deviceNumber);
        }
      },
      child: Text(isSelected ? 'Desligar Tomada $deviceNumber' : 'Ligar Tomada $deviceNumber'),
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