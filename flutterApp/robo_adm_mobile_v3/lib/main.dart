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
  WidgetsFlutterBinding.ensureInitialized(); 

 
  Logger.root.level = Level.ALL; 

  final logFile = File('${Directory.systemTemp.path}/log.txt'); 
  final logSink = logFile.openWrite(mode: FileMode.append);

  
  Logger.root.onRecord.listen((record) {
    final message = '${record.level.name}: ${record.time}: ${record.message}\n';

    
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      if (kDebugMode) {
        print(message);
      } 
      logSink.write(message); 
    } else if (record.level >= Level.WARNING) {
    
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
        '/controle': (context) => const ControlePage(connectedDevices: [], connections: []), 
        '/bluetooth': (context) => const MainScreen(connectedDevices: []),
        '/rotinas': (context) => const RotinasPage(connectedDevices: [], connections: []),
        '/testes': (context) => const Testetela(),
      },
    );
  }
}
