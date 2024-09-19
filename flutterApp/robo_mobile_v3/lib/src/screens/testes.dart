import 'package:flutter/material.dart';

class Testetela extends StatelessWidget {
  const Testetela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testes'),
      ),
      body: const Center(
        child: Text('Tela de Testes'),
      ),
    );
  }
}
