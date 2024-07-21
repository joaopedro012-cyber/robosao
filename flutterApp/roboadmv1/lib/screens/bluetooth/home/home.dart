import 'dart:async';
import 'package:roboadmv1/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:roboadmv1/screens/bluetooth/home/device_screen.dart';

void main() {
  runApp(const BluetoothPage());
}

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  StreamSubscription? _scanningStateSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUETOOTH'),
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
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Estado do Bluetooh"),
            subtitle: const Text("Clique para ativar"),
            trailing: Text(_adapterState.name),
            leading: const Icon(Icons.settings_bluetooth),
            onTap: () => _flutterBlueClassicPlugin.turnOn(),
          ),
          const Divider(),
          if (scanResults.isEmpty)
            const Center(child: Text("Não foram encontrados Dispositivos"))
          else
            for (var result in scanResults)
              ListTile(
                title: Text("${result.name ?? "???"} (${result.address})"),
                subtitle: Text(
                    "Bondstate: ${result.bondState.name}, Device type: ${result.type.name}"),
                trailing: Text("${result.rssi} dBm"),
                onTap: () async {
                  BluetoothConnection? connection;
                  try {
                    connection =
                        await _flutterBlueClassicPlugin.connect(result.address);
                    if (!this.context.mounted) return;
                    if (connection != null && connection.isConnected) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DeviceScreen(connection: connection!)));
                    }
                  } catch (e) {
                    if (kDebugMode) print(e);
                    connection?.dispose();
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(
                            content: Text("Erro ao conectar ao dispositivo")));
                  }
                },
              )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_isScanning) {
            _flutterBlueClassicPlugin.stopScan();
          } else {
            _scanResults.clear();
            _flutterBlueClassicPlugin.startScan();
          }
        },
        label: Text(_isScanning ? "Procurando..." : "Começar Busca"),
        icon: Icon(_isScanning ? Icons.bluetooth_searching : Icons.bluetooth),
      ),
    );
  }
}
