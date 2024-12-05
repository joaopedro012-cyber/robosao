import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/log.dart'; // Importando o LogModule

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  final LogModule logModule = LogModule(); // Instanciando o LogModule

  // Função para simular o movimento do robô e registrar eventos automaticamente
  void _simularMovimento() {
    // Simulação contínua de movimento, com logs sendo registrados em intervalos
    Future.delayed(const Duration(seconds: 2), () {
      logModule.registrarEvento("Movendo o robô para frente...");
      setState(() {}); // Atualiza a tela para mostrar o novo log
    });

    Future.delayed(const Duration(seconds: 5), () {
      logModule.registrarEvento("Robô parando.");
      setState(() {}); // Atualiza a tela para mostrar o novo log
    });

    Future.delayed(const Duration(seconds: 8), () {
      logModule.registrarEvento("Movendo o robô para a esquerda...");
      setState(() {}); // Atualiza a tela para mostrar o novo log
    });

    Future.delayed(const Duration(seconds: 11), () {
      logModule.registrarEvento("Robô parando.");
      setState(() {}); // Atualiza a tela para mostrar o novo log
    });

    // Repetir o movimento para continuar gerando logs
    Future.delayed(const Duration(seconds: 14), _simularMovimento);
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
