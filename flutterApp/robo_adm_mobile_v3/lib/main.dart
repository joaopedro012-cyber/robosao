import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'src/screens/home.dart';
import 'src/screens/bluetooth.dart';
import 'src/screens/controle.dart';
import 'src/screens/rotinas.dart';
import 'src/screens/testes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicialização necessária para chamadas assíncronas.

  // Configuração do nível de logging
  Logger.root.level = Level.ALL; // Agora captura todos os níveis de log.

  // Configuração do arquivo de log
  final logFile = File('${Directory.systemTemp.path}/log.txt'); 
  final logSink = logFile.openWrite(mode: FileMode.append);

  // Configuração para exibir logs no console e gravar no arquivo
  Logger.root.onRecord.listen((record) {
    final message = '${record.level.name}: ${record.time}: ${record.message}\n';

    // Exibir no console durante o desenvolvimento
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      if (kDebugMode) {
        print(message);
      } // Isso garante que o log apareça no console.
      logSink.write(message); // Também grava no arquivo.
    } else if (record.level >= Level.WARNING) {
      // No modo de produção, apenas logs de advertência e erro são gravados.
      logSink.write(message);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/controle': (context) => const ControlePage(connectedDevices: [], connections: []), // Passa uma lista vazia para connections
        '/bluetooth': (context) => const MainScreen(connectedDevices: []),
        '/rotinas': (context) => const RotinasPage(),
        '/testes': (context) => const Testetela(),
      },
    );
  }
}
