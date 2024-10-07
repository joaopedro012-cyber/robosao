import 'dart:async';  
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter/foundation.dart';
import 'controle.dart'; // Importa o controle
import 'package:robo_adm_mobile_v2/src/database/db.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.connectedDevices});

  final List<BluetoothDevice> connectedDevices;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;
  final Set<BluetoothDevice> _scanResults = {};
  final Map<String, bool> _selectedDevices = {};
  final Map<String, BluetoothConnection> _connectedDevices = {};
  StreamSubscription? _scanSubscription;
  bool _isScanning = false;
  StreamSubscription? _scanningStateSubscription;

  String? _robotUUID;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _fetchRobotUUID(); // Chame a função para buscar o UUID do robô
  }

  Future<void> initPlatformState() async {
    try {
      _adapterState = await _flutterBlueClassicPlugin.adapterStateNow;

      _adapterStateSubscription = _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });

      _scanSubscription = _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) {
          setState(() {
            _scanResults.add(device);
            _selectedDevices[device.address] = false;
          });
        }
      });

      _scanningStateSubscription = _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      if (kDebugMode) print('Erro: $e');
    }
  }

  // Nova função para buscar o UUID do robô no banco de dados
  Future<void> _fetchRobotUUID() async {
    final db = DB.instance; // Instância do banco de dados
    final uuid = await db.getRobotUUID(); // Método que você deve implementar no db.dart
    setState(() {
      _robotUUID = uuid; // Armazene o UUID na variável
    });
    
    // Use o UUID para alguma operação
    if (_robotUUID != null) {
      if (kDebugMode) {
        print("UUID do robô: $_robotUUID");
      }
    }
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      final connection = await _flutterBlueClassicPlugin.connect(device.address);
      if (mounted) {
        setState(() {
          _connectedDevices[device.address] = connection!;
          _selectedDevices[device.address] = true;
        });
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao conectar: $e');
    }
  }

  Future<void> _connectToDevices() async {
    final selectedDevices = _selectedDevices.entries.where((entry) => entry.value).map((entry) => entry.key).toList();

    if (selectedDevices.isNotEmpty) {
      List<Future<void>> connectionFutures = [];

      for (String address in selectedDevices) {
        final device = _scanResults.firstWhere((d) => d.address == address);
        if (!_connectedDevices.containsKey(address)) {
          connectionFutures.add(_connectToDevice(device));
        }
      }

      await Future.wait(connectionFutures);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlePage(
              connectedDevices: _scanResults.where((d) => _connectedDevices.containsKey(d.address)).toList(),
              connections: _connectedDevices.values.toList(),
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conexão bem-sucedida!')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhum dispositivo selecionado.')));
      }
    }
  }

  void _startStopScan() {
    if (_isScanning) {
      _flutterBlueClassicPlugin.stopScan();
    } else {
      _scanResults.clear();
      _flutterBlueClassicPlugin.startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        actions: [
          if (_adapterState == BluetoothAdapterState.on)
            IconButton(
              icon: const Icon(Icons.bluetooth_disabled),
              onPressed: () {
                for (var device in _connectedDevices.keys) {
                  _disconnectFromDevice(scanResults.firstWhere((d) => d.address == device));
                }
              },
              tooltip: 'Desconectar Bluetooth',
            ),
          if (_adapterState != BluetoothAdapterState.on)
            IconButton(
              icon: const Icon(Icons.bluetooth),
              onPressed: () => _flutterBlueClassicPlugin.turnOn(),
              tooltip: 'Ligar Bluetooth',
            ),
        ],
      ),
      body: Column(
        children: [
          if (_adapterState == BluetoothAdapterState.on)
            Expanded(
              child: ListView(
                children: scanResults.isEmpty
                    ? [const Center(child: Text("Nenhum dispositivo encontrado"))]
                    : scanResults.map((device) {
                        final isConnected = _connectedDevices.containsKey(device.address);
                        return CheckboxListTile(
                          title: Text(device.name ?? "Dispositivo desconhecido"),
                          subtitle: Text(device.address),
                          value: _selectedDevices[device.address],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedDevices[device.address] = value ?? false;
                            });

                            if (value == true && !isConnected) {
                              _connectToDevice(device);
                            } else if (value == false && isConnected) {
                              _disconnectFromDevice(device);
                            }
                          },
                          secondary: Icon(isConnected ? Icons.check_box : Icons.check_box_outline_blank),
                        );
                      }).toList(),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _connectToDevices,
                child: const Text('Conectar'),
              ),
              ElevatedButton(
                onPressed: _startStopScan,
                child: Text(_isScanning ? 'Parar Busca' : 'Procurar Dispositivos'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _adapterState == BluetoothAdapterState.on
          ? FloatingActionButton(
              onPressed: _startStopScan,
              child: Icon(_isScanning ? Icons.bluetooth_searching : Icons.search),
            )
          : null,
    );
  }

  Future<void> _disconnectFromDevice(BluetoothDevice device) async {
    try {
      final connection = _connectedDevices[device.address];
      if (connection != null) {
        connection.dispose();
        if (mounted) {
          setState(() {
            _connectedDevices.remove(device.address);
            _selectedDevices[device.address] = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao desconectar: $e');
    }
  }
}
