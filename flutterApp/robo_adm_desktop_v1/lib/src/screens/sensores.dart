import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Classe do sensor ultrassônico para controle do robô
class SensorUltrassonico {
  final int triggerPin;
  final int echoPin;

  SensorUltrassonico(this.triggerPin, this.echoPin);

  Future<double> medirDistancia() async {
    await Future.delayed(const Duration(microseconds: 10));

    int startTime = 0;
    int endTime = 0;

    startTime = DateTime.now().microsecondsSinceEpoch;

    await Future.delayed(const Duration(milliseconds: 100)); // Simula o tempo de resposta do sensor
    endTime = DateTime.now().microsecondsSinceEpoch;

    int duracao = endTime - startTime;
    double distancia = duracao / 58.0; // A constante 58 é baseada na velocidade do som
    return distancia;
  }
}

// Classe do robô que utiliza 12 sensores ultrassônicos em posições específicas
class RoboTriangular {
  static const double distanciaMinimaDefault = 25.0;
  final List<SensorUltrassonico> sensores;
  double distanciaMinima;
  Function pauseRoutine;
  Function resumeRoutine;

  RoboTriangular(this.sensores, {this.distanciaMinima = distanciaMinimaDefault, required this.pauseRoutine, required this.resumeRoutine});

  void parar() {
    if (kDebugMode) {
      print("Robô parado.");
    }
  }

  void moverParaTras() {
    if (kDebugMode) {
      print("Movendo para trás...");
    }
  }

  void girarEsquerda() {
    if (kDebugMode) {
      print("Girando para a esquerda...");
    }
  }

  void girarDireita() {
    if (kDebugMode) {
      print("Girando para a direita...");
    }
  }

  void moverParaFrente() {
    if (kDebugMode) {
      print("Movendo para frente...");
    }
  }

  Future<void> monitorarSensores() async {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      List<double> distancias = await Future.wait(
        sensores.map((sensor) => sensor.medirDistancia()).toList(),
      );

      if (distancias[0] < distanciaMinima ||
          distancias[1] < distanciaMinima ||
          distancias[8] < distanciaMinima ||
          distancias[9] < distanciaMinima) {
        pauseRoutine(); // Pausa a rotina
        parar();
        moverParaTras();
        girarDireita(); 
        Future.delayed(const Duration(seconds: 1), () {
          moverParaFrente();
          resumeRoutine(); // Retoma a rotina
        });
      } else {
        moverParaFrente();
      }
    });
  }
}

// Interface Flutter para configurar sensores
class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  double distanciaMinima = RoboTriangular.distanciaMinimaDefault;

  void pauseRoutine() {
    // Lógica para pausar a execução da rotina
    print("Rotina pausada");
  }

  void resumeRoutine() {
    // Lógica para retomar a execução da rotina
    print("Rotina retomada");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Distância mínima configurada: $distanciaMinima cm"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              distanciaMinima = 30.0; // Modifique o valor conforme necessário
            });
          },
          child: const Text("Definir distância mínima"),
        ),
      ],
    );
  }
}

void main() {
  var sensores = [
    SensorUltrassonico(17, 18),
    SensorUltrassonico(19, 20),
    SensorUltrassonico(21, 22),
    SensorUltrassonico(23, 24),
    SensorUltrassonico(25, 26),
    SensorUltrassonico(27, 28),
    SensorUltrassonico(29, 30),
    SensorUltrassonico(31, 32),
    SensorUltrassonico(33, 34),
    SensorUltrassonico(35, 36),
    SensorUltrassonico(37, 38),
    SensorUltrassonico(39, 40),
  ];

  var robo = RoboTriangular(
    sensores,
    pauseRoutine: () => print("Pausado"),
    resumeRoutine: () => print("Retomando"),
  );

  // Inicia o monitoramento dos sensores
  robo.monitorarSensores();

  runApp(
    const MaterialApp(
      home: SensoresPage(),
    ),
  );
}
