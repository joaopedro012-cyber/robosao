import 'package:flutter/material.dart'; 
import 'package:logging/logging.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:robo_adm_mobile_v2/src/database/db.dart';

final log = Logger('JoystickLogger');

class ControlePage extends StatefulWidget {
  final List<BluetoothDevice> connectedDevices;

  const ControlePage({super.key, required this.connectedDevices});

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

  void turnOnDevice(int deviceNumber) async {
    if (_selectedRoutine != null) {
      log.info('Ligando a tomada $deviceNumber');
      await _db.insertAcao(
        idRotina: int.parse(_selectedRoutine!),
        acaoHorizontal: 'Ligar Tomada $deviceNumber',
        acaoVertical: '',
        acaoPlataforma: '',
        acaoBotao1: '',
        acaoBotao2: '',
        acaoBotao3: '',
        qtdHorizontal: 0,
        qtdVertical: 0,
        qtdPlataforma: 0,
        qtdBotao1: 0,
        qtdBotao2: 0,
        qtdBotao3: 0,
        dtExecucao: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  void turnOffDevice(int deviceNumber) async {
    if (_selectedRoutine != null) {
      log.info('Desligando a tomada $deviceNumber');
      await _db.insertAcao(
        idRotina: int.parse(_selectedRoutine!),
        acaoHorizontal: 'Desligar Tomada $deviceNumber',
        acaoVertical: '',
        acaoPlataforma: '',
        acaoBotao1: '',
        acaoBotao2: '',
        acaoBotao3: '',
        qtdHorizontal: 0,
        qtdVertical: 0,
        qtdPlataforma: 0,
        qtdBotao1: 0,
        qtdBotao2: 0,
        qtdBotao3: 0,
        dtExecucao: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  void movePlatform(double position) async {
    if (_selectedRoutine != null) {
      log.info('Movendo a plataforma para: $position');
      await _db.insertAcao(
        idRotina: int.parse(_selectedRoutine!),
        acaoHorizontal: '',
        acaoVertical: '',
        acaoPlataforma: 'Movendo Plataforma para ${position * 100}%',
        acaoBotao1: '',
        acaoBotao2: '',
        acaoBotao3: '',
        qtdHorizontal: 0,
        qtdVertical: 0,
        qtdPlataforma: (position * 100).toInt(),
        qtdBotao1: 0,
        qtdBotao2: 0,
        qtdBotao3: 0,
        dtExecucao: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      log.warning('Nenhuma rotina selecionada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
      ),
      body: Container(
        color: const Color(0xFFECE6F0),
        child: Column(
          children: [
            // Dropdown para selecionar a rotina
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 200,
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
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Joystick Vertical
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        JoystickVertical(movePlatform: movePlatform),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // Slider Vertical para mover a plataforma
                    RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        width: 180,
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
                            movePlatform(value / 100);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Coluna para os botões de controle
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTomadaButton(1),
                        const SizedBox(height: 8),
                        _buildTomadaButton(2),
                        const SizedBox(height: 8),
                        _buildTomadaButton(3),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // Joystick Horizontal
                    const JoystickHorizontal(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar os botões de controle das tomadas
  Widget _buildTomadaButton(int deviceNumber) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _tomadaSelecionada[deviceNumber - 1] = !_tomadaSelecionada[deviceNumber - 1];
          });
          if (_tomadaSelecionada[deviceNumber - 1]) {
            turnOnDevice(deviceNumber);
          } else {
            turnOffDevice(deviceNumber);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _tomadaSelecionada[deviceNumber - 1]
              ? const Color.fromARGB(255, 223, 165, 252)
              : const Color.fromARGB(255, 56, 33, 114),
          foregroundColor: Colors.white,
        ),
        child: Text(
          _tomadaSelecionada[deviceNumber - 1]
              ? 'Desligar Tomada $deviceNumber'
              : 'Ligar Tomada $deviceNumber',
        ),
      ),
    );
  }
}

// Widget para o joystick vertical (cima e baixo)
class JoystickVertical extends StatefulWidget {
  final Function(double) movePlatform;

  const JoystickVertical({super.key, required this.movePlatform});

  @override
  JoystickVerticalState createState() => JoystickVerticalState();
}

class JoystickVerticalState extends State<JoystickVertical> {
  double _yOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _yOffset += details.delta.dy;

          if (_yOffset > 40) _yOffset = 40;
          if (_yOffset < -40) _yOffset = -40;

          widget.movePlatform(_yOffset / 40);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _yOffset = 0;
        });
        widget.movePlatform(0);
      },
      child: Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF65558F),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: Offset(0, _yOffset),
            child: const Icon(Icons.circle, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _xOffset += details.delta.dx;

          if (_xOffset > 40) _xOffset = 40;
          if (_xOffset < -40) _xOffset = -40;
        });
      },
      onPanEnd: (details) {
        setState(() {
          _xOffset = 0;
        });
      },
      child: Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF65558F),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: Offset(_xOffset, 0),
            child: const Icon(Icons.circle, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
