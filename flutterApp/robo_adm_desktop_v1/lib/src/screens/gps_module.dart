import 'dart:async';
import 'package:flutter/material.dart';

class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  // Função que simula a coleta dos dados GPS
  Future<void> coletarDados() async {
    // Simulação de coleta de dados GPS (substitua por lógica real)
    await Future.delayed(
        const Duration(seconds: 2)); // Simulando atraso na coleta
    latitude = 40.7128; // Exemplo: Nova York
    longitude = -74.0060;
  }

  String obterLocalizacao() {
    return 'Latitude: $latitude, Longitude: $longitude';
  }
}

class GPSModuleWidget extends StatefulWidget {
  const GPSModuleWidget({super.key});

  @override
  GPSModuleWidgetState createState() => GPSModuleWidgetState();
}

class GPSModuleWidgetState extends State<GPSModuleWidget> {
  final GPSModule gpsModule = GPSModule();
  String localizacao = "Aguardando...";

  @override
  void initState() {
    super.initState();
    _atualizarLocalizacao();
  }

  // Função para atualizar a localização
  Future<void> _atualizarLocalizacao() async {
    await gpsModule.coletarDados();
    setState(() {
      localizacao = gpsModule.obterLocalizacao();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Module'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizacao,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _atualizarLocalizacao,
              child: const Text(
                'Atualizar Localização',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  localizacao = "Aguardando...";
                });
              },
              child: const Text(
                'Resetar Localização',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GPSModuleWidget(),
    ),
  );
}
