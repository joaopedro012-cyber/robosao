import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/log.dart'; // Importando o LogModule

// Página que exibe os logs de eventos do robô
class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  final LogModule logModule = LogModule(); // Instanciando o LogModule para registrar e obter os logs

  // Variáveis que armazenam o estado atual do robô e do Arduino
  String statusRobo = 'Parado'; 
  String statusArduino = 'Funcionando';

  // Função para simular o movimento do robô e registrar eventos automaticamente
  void _simularMovimento() {
    // Simulação de movimento, com logs sendo registrados em intervalos de tempo

    // Movendo o robô para frente
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        statusRobo = 'Movendo para frente...'; // Atualiza o status do robô
        logModule.registrarEvento("Movendo o robô para frente..."); // Registra o evento
      });
    });

    // Parando o robô
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        statusRobo = 'Parado';
        logModule.registrarEvento("Robô parando.");
      });
    });

    // Movendo o robô para a esquerda
    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        statusRobo = 'Movendo para a esquerda...';
        logModule.registrarEvento("Movendo o robô para a esquerda...");
      });
    });

    // Parando o robô novamente
    Future.delayed(const Duration(seconds: 11), () {
      setState(() {
        statusRobo = 'Parado';
        logModule.registrarEvento("Robô parando.");
      });
    });

    // Simulando uma falha no Arduino
    Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        statusArduino = 'Parou de funcionar';
        logModule.registrarEvento("Arduino parou de funcionar.");
      });
    });

    // Repetindo o movimento após 24 segundos, para continuar gerando logs
    Future.delayed(const Duration(seconds: 24), _simularMovimento);
  }

  @override
  void initState() {
    super.initState();
    _simularMovimento(); // Inicia a simulação de movimento assim que a tela é carregada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log de Eventos'),
      ),
      body: Column(
        children: [
          // Exibindo o estado atual do robô
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Status do Robô: $statusRobo', // Exibe o status do robô
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusRobo == 'Parado' ? Colors.red : Colors.green, // Alterando a cor com base no status
              ),
            ),
          ),
          // Exibindo o estado do Arduino
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Status do Arduino: $statusArduino', // Exibe o status do Arduino
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusArduino == 'Funcionando' ? Colors.green : Colors.red, // Alterando a cor com base no status
              ),
            ),
          ),
          // Exibindo os logs na tela
          Expanded(
            child: ListView.builder(
              itemCount: logModule.obterLogs().length, // Obtém a quantidade de logs registrados
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(logModule.obterLogs()[index]), // Exibe cada log
                );
              },
            ),
          ),
          // Botão para salvar os logs em um arquivo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                logModule.salvarLogEmArquivo(); // Chama a função para salvar os logs em arquivo
              },
              child: const Text('Salvar Logs'),
            ),
          ),
        ],
      ),
    );
  }
}
