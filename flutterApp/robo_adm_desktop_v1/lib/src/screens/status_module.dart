import 'package:flutter/material.dart';

// Classe StatusModule (já fornecida)
class StatusModule {
  String movimento = 'Parado';
  double velocidade = 0.0;
  int bateria = 100;

  // Método para atualizar o status
  void atualizarStatus(
      String novoMovimento, double novaVelocidade, int novaBateria) {
    movimento = novoMovimento;
    velocidade = novaVelocidade;
    bateria = novaBateria;
  }

  // Método para obter o status atual
  String obterStatus() {
    return 'Movimento: $movimento, Velocidade: $velocidade m/s, Bateria: $bateria%';
  }
}

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  StatusPageState createState() => StatusPageState();
}

class StatusPageState extends State<StatusPage> {
  // Instanciando o StatusModule
  final StatusModule statusModule = StatusModule();

  // Método para simular atualização do status
  void _atualizarStatus() {
    setState(() {
      // Atualizando o status com novos valores (simulação de novos dados)
      statusModule.atualizarStatus(
        'Em Movimento',
        2.5, // Velocidade simulada em m/s
        85, // Bateria simulada (85%)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status do Robô')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibindo o status atual
            Text(
              'Status Atual:',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Mudança para titleLarge
            ),
            const SizedBox(height: 10),
            Text(
              statusModule.obterStatus(), // Exibindo o status formatado
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge, // Mudança para bodyLarge
            ),
            const SizedBox(height: 20),
            // Botão para atualizar o status
            ElevatedButton(
              onPressed: _atualizarStatus,
              child: const Text('Atualizar Status'),
            ),
          ],
        ),
      ),
    );
  }
}
