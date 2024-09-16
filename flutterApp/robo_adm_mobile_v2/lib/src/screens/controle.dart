import 'package:flutter/material.dart';

class ControlePage extends StatelessWidget {
  const ControlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
      ),
      body: const Center(
        child: Text('Tela de Controle'),
      ),
    );
  }
}
