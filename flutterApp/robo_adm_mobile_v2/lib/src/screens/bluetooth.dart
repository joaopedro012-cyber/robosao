import 'package:flutter/material.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: const Center(
        child: Text('Tela de Bluetooth'),
      ),
    );
  }
}
