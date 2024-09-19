import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'src/screens/home.dart';
import 'src/screens/bluetooth.dart'; // Certifique-se de que o nome do arquivo está correto
import 'src/screens/controle.dart';
import 'src/screens/rotinas.dart';
import 'src/screens/testes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Initialize logging
  Logger.root.level = Level.INFO; // Set the log level to INFO or whatever level you need

  // Configure log output
  final logFile = File('${Directory.systemTemp.path}/log.txt'); // Use a path in the system's temporary directory
  final logSink = logFile.openWrite(mode: FileMode.append);

  Logger.root.onRecord.listen((record) {
    final message = '${record.level.name}: ${record.time}: ${record.message}\n';
    
    // Handle logging output
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      // Log all records in debug mode
      logSink.write(message);
    } else if (record.level >= Level.WARNING) {
      // Log warnings and errors in production
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
        '/controle': (context) => const ControlePage(connectedDevices: [],),
        '/bluetooth': (context) => const MainScreen(),
        '/rotinas': (context) => const RotinasPage(),
        '/testes': (context) => const Testetela(),
      },
    );
  }
}
