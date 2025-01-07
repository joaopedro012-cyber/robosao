import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/log.dart'; // Importando o LogModule

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  final LogModule logModule = LogModule(); // Instanciando o LogModule

  String statusRobo = 'Parado'; // Variável para armazenar o estado do robô
  String statusArduino = 'Funcionando'; // Variável para armazenar o estado do Arduino

  // Função para simular o movimento do robô e registrar eventos automaticamente
  void _simularMovimento() {
    // Simulação de movimento, com logs sendo registrados em intervalos

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        statusRobo = 'Movendo para frente...';
        logModule.registrarEvento("Movendo o robô para frente...");
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        statusRobo = 'Parado';
        logModule.registrarEvento("Robô parando.");
      });
    });

    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        statusRobo = 'Movendo para a esquerda...';
        logModule.registrarEvento("Movendo o robô para a esquerda...");
      });
    });

    Future.delayed(const Duration(seconds: 11), () {
      setState(() {
        statusRobo = 'Parado';
        logModule.registrarEvento("Robô parando.");
      });
    });

    // Simulação de falha no Arduino
    Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        statusArduino = 'Parou de funcionar';
        logModule.registrarEvento("Arduino parou de funcionar.");
      });
    });

    // Repetir o movimento para continuar gerando logs
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
              'Status do Robô: $statusRobo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusRobo == 'Parado' ? Colors.red : Colors.green,
              ),
            ),
          ),
          // Exibindo o estado do Arduino
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Status do Arduino: $statusArduino',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusArduino == 'Funcionando' ? Colors.green : Colors.red,
              ),
            ),
          ),
          // Exibindo os logs na tela
          Expanded(
            child: ListView.builder(
              itemCount: logModule.obterLogs().length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(logModule.obterLogs()[index]),
                );
              },
            ),
          ),
          // Botão para salvar os logs em um arquivo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                logModule.salvarLogEmArquivo(); // Salva os logs em um arquivo
              },
              child: const Text('Salvar Logs'),
            ),
          ),
        ],
      ),
    );
  }
}
