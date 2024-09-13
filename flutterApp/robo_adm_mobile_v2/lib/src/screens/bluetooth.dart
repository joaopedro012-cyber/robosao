import 'package:flutter/material.dart';

class TelaBluetooth extends StatelessWidget{
  const TelaBluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexão Bluetooth'),
      ),
      body: const Center(
        child: Text('bem-vindo'),
      ),
    );
  }
}
