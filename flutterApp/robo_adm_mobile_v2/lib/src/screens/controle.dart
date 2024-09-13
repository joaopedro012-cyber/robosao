import 'package:flutter/material.dart';

class Teladecontrole extends StatelessWidget{
  const Teladecontrole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('controle para pre produção'),
      ),
      body: const Center(
        child: Text('bem-vindo'),
      ),
    );
  }
}