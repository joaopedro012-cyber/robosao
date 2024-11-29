// lib/src/log.dart

import 'dart:io';

class LogModule {
  final List<String> logs = [];

  // Método para registrar um evento no log
  void registrarEvento(String evento) {
    final DateTime agora = DateTime.now();
    logs.add('[${agora.toIso8601String()}] $evento');
  }

  // Método para salvar os logs em um arquivo
  void salvarLogEmArquivo() async {
    final Directory diretorio = await Directory.systemTemp.createTemp('logs');
    final File arquivoLog = File('${diretorio.path}/log.txt');

    await arquivoLog.writeAsString(logs.join('\n'), flush: true);
    print('Logs salvos em: ${arquivoLog.path}');
  }

  // Método para obter todos os logs
  List<String> obterLogs() {
    return logs;
  }
}
