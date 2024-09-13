import 'package:flutter/material.dart';
import '/src/widgets/cardbotao.dart';

class Teste1234 extends StatelessWidget {
  const Teste1234({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            CardBotao(
              title: 'Testes',
              subtitle: 'Ambiente de Testes.',
              buttonText: 'TESTAR',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestarPage()),
                );
              },
            ),
            CardBotao(
              title: 'Rotinas',
              subtitle: 'Criar, Editar, Exportar Rotinas',
              buttonText: 'Rotinas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RotinasPage()),
                );
              },
            ),
            CardBotao(
              title: 'Controle',
              subtitle: 'Controle para pré-produção',
              buttonText: 'Abrir',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AbrirPage()),
                );
              },
            ),
            CardBotao(
              title: 'Bluetooth',
              subtitle: 'Conexão e Controle',
              buttonText: 'Conectar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConectarPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Definições fictícias das páginas de destino

class TestarPage extends StatelessWidget {
  const TestarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testar')),
      body: const Center(child: Text('Página de Testar')),
    );
  }
}

class RotinasPage extends StatelessWidget {
  const RotinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rotinas')),
      body: const Center(child: Text('Página de Rotinas')),
    );
  }
}

class AbrirPage extends StatelessWidget {
  const AbrirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abrir')),
      body: const Center(child: Text('Página de Abrir')),
    );
  }
}

class ConectarPage extends StatelessWidget {
  const ConectarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conectar')),
      body: const Center(child: Text('Página de Conectar')),
    );
  }
}
