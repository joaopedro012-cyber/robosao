import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/log.dart'; // Importando o LogModule

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  final LogModule logModule = LogModule(); // Instanciando o LogModule

  // Função para simular o movimento do robô
  void _simularMovimento() {
    Future.delayed(const Duration(seconds: 2), () {
      // Registrando eventos automaticamente
      logModule.registrarEvento("Movendo o robô para frente...");
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 5), () {
      logModule.registrarEvento("Robô parando.");
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 8), () {
      logModule.registrarEvento("Movendo o robô para a esquerda...");
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 11), () {
      logModule.registrarEvento("Robô parando.");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _simularMovimento(); // Iniciar a simulação do movimento e registro dos eventos
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
