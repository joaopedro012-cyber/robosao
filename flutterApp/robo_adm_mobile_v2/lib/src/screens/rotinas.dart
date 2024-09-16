import 'package:flutter/material.dart';

class Telarotina extends StatelessWidget {
  const Telarotina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotinas'),
      ),
      body: const Center(
        child: Text('Tela de Rotinas'),
      ),
    );
  }
}
