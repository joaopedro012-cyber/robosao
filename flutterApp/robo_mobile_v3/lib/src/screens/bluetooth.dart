import 'dart:convert'; // Para utf8.encode
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart'; // Adicione isto para permissões
import 'dart:async'; // Para uso do Timer

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _selectedDevice;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isReconnecting = false; // Novo estado para reconexão
  String? _errorMessage; // Armazena mensagens de erro
  Timer? _reconnectTimer; // Para o timer de reconexão

  final Logger _logger = Logger('BluetoothPage');

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
    _requestPermissions();
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel(); // Cancela o timer de reconexão ao destruir o widget
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    // Log de permissões
    _logger.info('Bluetooth Scan Permission: $bluetoothScanStatus');
    _logger.info('Bluetooth Connect Permission: $bluetoothConnectStatus');
    _logger.info('Location Permission: $locationStatus');

    if (bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted) {
      _discoverDevices();
    } else {
      _logger.warning('Permissões de Bluetooth ou localização não foram concedidas.');
      setState(() {
        _errorMessage = 'As permissões necessárias não foram concedidas.';
      });
    }
  }

  Future<void> _checkBluetoothState() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    setState(() {});
  }

  void _discoverDevices() async {
    final bluetoothConnectPermission = await Permission.bluetoothConnect.status;
    final locationWhenInUsePermission = await Permission.locationWhenInUse.status;

    _logger.info('Bluetooth Connect Permission: $bluetoothConnectPermission');
    _logger.info('Location When In Use Permission: $locationWhenInUsePermission');

    if (bluetoothConnectPermission.isGranted && locationWhenInUsePermission.isGranted) {
      _devicesList = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {});
    } else {
      _logger.warning('Permissões necessárias não foram concedidas.');
      setState(() {
        _errorMessage = 'As permissões necessárias não foram concedidas.';
      });
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _selectedDevice = device;
      _isConnecting = true;
      _isReconnecting = false; // Reinicia o estado de reconexão
      _errorMessage = null;
    });

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _isConnected = true;
        _isConnecting = false;
      });

      _connection!.input!.listen((data) {
        _logger.info('Data incoming: ${String.fromCharCodes(data)}');
      }).onDone(() {
        _logger.warning('Connection disconnected');
        _handleDisconnection(); // Gerencia a desconexão
      });
    } catch (e) {
      _logger.severe('Cannot connect, exception occurred: $e');
      setState(() {
        _isConnecting = false;
        _errorMessage = 'Não foi possível conectar: $e';
      });
    }
  }

  void _handleDisconnection() {
    setState(() {
      _isConnected = false;
    });

    // Tentativa de reconexão se já houver um dispositivo selecionado
    if (_selectedDevice != null) {
      _startReconnect();
    }
  }

  void _startReconnect() {
    if (!_isReconnecting) {
      setState(() {
        _isReconnecting = true;
      });

      // Tenta reconectar a cada 5 segundos
      _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!_isConnected && _selectedDevice != null) {
          _logger.info('Tentando reconectar ao dispositivo...');
          _connectToDevice(_selectedDevice!);
        } else {
          timer.cancel(); // Para o timer se reconectar com sucesso
          _logger.info('Reconexão bem-sucedida.');
        }
      });
    }
  }

  void _disconnect() async {
    if (_isConnected) {
      await _connection?.close();
      setState(() {
        _isConnected = false;
        _connection = null;
      });
    }
  }

  void _sendData(String data) {
    if (_isConnected) {
      _connection!.output.add(utf8.encode(data));
      _logger.info('Data sent: $data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth with Arduino'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Bluetooth State: $_bluetoothState'),
          ),
          ElevatedButton(
            onPressed: _discoverDevices,
            child: const Text('Refresh Devices'),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _devicesList.length,
              itemBuilder: (context, index) {
                final device = _devicesList[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown device'),
                  subtitle: Text(device.address),
                  selected: device == _selectedDevice,
                  trailing: _selectedDevice == device
                      ? _isConnected
                          ? ElevatedButton(
                              onPressed: _disconnect,
                              child: const Text('Disconnect'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (!_isConnecting) {
                                  _connectToDevice(device);
                                }
                              },
                              child: _isConnecting
                                  ? const CircularProgressIndicator()
                                  : const Text('Connect'),
                            )
                      : ElevatedButton(
                          onPressed: () {
                            if (!_isConnecting) {
                              _connectToDevice(device);
                            }
                          },
                          child: const Text('Connect'),
                        ),
                );
              },
            ),
          ),
          if (_isConnecting)
            const CircularProgressIndicator()
          else if (_isConnected)
            ElevatedButton(
              onPressed: () {
                _sendData('Hello Arduino');
              },
              child: const Text('Send Data'),
            )
          else if (_isReconnecting)
            const Text('Tentando reconectar...')
          else
            Container(),
        ],
      ),
    );
  }
}
