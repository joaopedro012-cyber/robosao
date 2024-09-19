import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administração'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildMenuItem(
              context,
              'Bluetooth',
              'Conecte e controle.',
              '/bluetooth',
            ),
            _buildMenuItem(
              context,
              'Controle',
              'Joystick que cria rotinas.',
              '/controle',
            ),
            _buildMenuItem(
              context,
              'Rotinas',
              'Edição, Exclusão,.',
              '/rotinas',
            ),
            _buildMenuItem(
              context,
              'Testes',
              'Ambiente de testes interno.',
              '/testes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String description, String route) {
    return Card(
      color: const Color.fromARGB(255, 250, 249, 249),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 15, 15, 15)),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color.fromARGB(179, 14, 13, 13)),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                child: const Text('VER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
