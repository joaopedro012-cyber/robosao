import 'dart:async';
import 'package:flutter/material.dart';

// Classe StatusModule
class StatusModule {
  String movimento = 'Parado';
  double gasolina = 0.0; // Quantidade de gasolina em litros
  String tempoRestante = '0 horas'; // Tempo restante em horas

  // Método para atualizar o status
  void atualizarStatus(
      String novoMovimento, double novaGasolina) {
    movimento = novoMovimento;
    gasolina = novaGasolina;
    tempoRestante = calcularTempoRestante(gasolina);
  }

  // Método para calcular o tempo restante baseado na quantidade de gasolina
  String calcularTempoRestante(double gasolina) {
    if (gasolina <= 0) {
      return 'Sem gasolina';
    }
    double horas = gasolina;
    return '${horas.toStringAsFixed(1)} horas'; // Exibindo com 1 casa decimal
  }
}

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  StatusPageState createState() => StatusPageState();
}

class StatusPageState extends State<StatusPage> {
  final StatusModule statusModule = StatusModule();
  final TextEditingController gasolinaController = TextEditingController();

  Timer? _timer;
  int _tempoRestanteEmSegundos = 0;

  void _atualizarStatus() {
    setState(() {
      double gasolina = double.tryParse(gasolinaController.text) ?? 0.0;

      statusModule.atualizarStatus(
        'Em Movimento',
        gasolina,
      );

      _tempoRestanteEmSegundos = (gasolina * 3600).toInt(); // Convertendo horas para segundos
      _iniciarCronometro();
    });
  }

  void _iniciarCronometro() {
    if (_timer != null) {
      _timer?.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tempoRestanteEmSegundos > 0) {
          _tempoRestanteEmSegundos--;
          statusModule.tempoRestante = _formatarTempo(_tempoRestanteEmSegundos);
        } else {
          _timer?.cancel();
          statusModule.tempoRestante = 'Sem gasolina';
        }
      });
    });
  }

  String _formatarTempo(int segundos) {
    int horas = segundos ~/ 3600;
    int minutos = (segundos % 3600) ~/ 60;
    int segundosRestantes = segundos % 60;
    return '${_formatarNumero(horas)}:${_formatarNumero(minutos)}:${_formatarNumero(segundosRestantes)}';
  }

  String _formatarNumero(int numero) {
    return numero.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status do Robô'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Card para exibir o status
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Status Atual',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Movimento: ${statusModule.movimento}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tempo Restante: ${statusModule.tempoRestante}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: statusModule.tempoRestante == 'Sem gasolina'
                                ? Colors.red
                                : Colors.green,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Campo de texto para inserir a quantidade de gasolina
            TextField(
              controller: gasolinaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Insira a quantidade de gasolina (litros)',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.teal.shade50,
              ),
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // Botão para atualizar o status e iniciar o cronômetro
            ElevatedButton(
              onPressed: _atualizarStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Alterado para backgroundColor
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Iniciar Cronômetro',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
