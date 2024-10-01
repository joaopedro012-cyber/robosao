import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter/foundation.dart';
import 'controle.dart'; // Importa a tela de controle

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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      _adapterState = await _flutterBlueClassicPlugin.adapterStateNow;

      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });

      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) {
          setState(() {
            _scanResults.add(device);
            _selectedDevices[device.address] = false;
          });
        }
      });

      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro: $e');
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

        // Navegar para a tela de controle após conectar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlePage(
              connectedDevices: _scanResults.where((d) => _connectedDevices.containsKey(d.address)).toList(), // Passa a lista de dispositivos conectados
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao conectar: $e');
      }
    }
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
      if (kDebugMode) {
        print('Erro ao desconectar: $e');
      }
    }
  }

  void _connectToDevices() {
    final selectedDevices = _selectedDevices.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedDevices.isNotEmpty) {
      for (String address in selectedDevices) {
        final device = _scanResults.firstWhere((d) => d.address == address);
        if (!_connectedDevices.containsKey(address)) {
          _connectToDevice(device);
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum dispositivo selecionado.')));
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
              onPressed: () {
                _flutterBlueClassicPlugin.turnOn();
              },
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
                        final isConnected =
                            _connectedDevices.containsKey(device.address);
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
                          secondary: Icon(
                            isConnected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
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
              child: Icon(_isScanning
                  ? Icons.bluetooth_searching
                  : Icons.search),
            )
          : null,
    );
  }
}