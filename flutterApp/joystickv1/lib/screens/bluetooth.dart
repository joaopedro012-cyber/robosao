import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MaterialApp(
    home: bluetoothPage(),
  ));
}

class bluetoothPage extends StatefulWidget {
  const bluetoothPage({super.key});
  @override
  bluetoothPageState createState() => bluetoothPageState();
}

class bluetoothPageState extends State<bluetoothPage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> availableDevices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() {
    flutterBlue.startScan(timeout: const Duration(seconds: 60));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        availableDevices = results.map((result) => result.device).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF7171d5),
          title: const Text(
            'Conexões Bluetooth',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 14, left: 14),
          child: Wrap(
            spacing: 16,
            children: [
              const Expanded(
                child: Text(
                  'DISPOSITIVOS CONECTADOS:',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text(
                  'DISPOSITIVOS DISPONÍVEIS:',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableDevices.length,
                  itemBuilder: (context, index) {
                    final device = availableDevices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id.toString()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
