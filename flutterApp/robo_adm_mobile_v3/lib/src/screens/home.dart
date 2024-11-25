import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a orientação da tela
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administração',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true, // Centraliza o título do AppBar
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4, // Ajusta o número de colunas com base na orientação
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.8, // Ajusta o aspecto dos itens para evitar overflow
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
              'Edição, Exclusão.',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
      ),
      elevation: 5,
      color: const Color.fromARGB(255, 250, 249, 249),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 15, 15, 15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center, // Centraliza o texto
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(179, 14, 13, 13),
                ),
              ),
              const Spacer(),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, route);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 8, // Elevação para criar profundidade
                    shadowColor: Colors.black.withOpacity(0.4), // Cor da sombra
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                    ),
                    backgroundColor:
                        const Color.fromARGB(255, 151, 197, 213), // Cor de fundo do botão
                  ),
                  child: const Text(
                    'VER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 64, 59, 59), // Cor do texto
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
