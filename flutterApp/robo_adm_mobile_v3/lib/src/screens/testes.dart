import 'package:flutter/material.dart';

class Testetela extends StatelessWidget {
  const Testetela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Testes',
          style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centraliza o título do AppBar
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
        toolbarHeight: 70.0,
      ),
      body: const Center(
        child: Text('Tela de Testes'),
      ),
    );
  }
}
