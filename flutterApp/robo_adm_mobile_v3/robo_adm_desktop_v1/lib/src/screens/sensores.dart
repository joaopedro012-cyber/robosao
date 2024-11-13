import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
import 'package:robo_adm_desktop_v1/src/widgets/sensor_rotina.dart';
import 'dart:async';

// Classe do sensor ultrassônico para controle do robô
class SensorUltrassonico {
  final int triggerPin;
  final int echoPin;

  SensorUltrassonico(this.triggerPin, this.echoPin);

  // Função para medir a distância usando o sensor ultrassônico
  Future<double> medirDistancia() async {
    await Future.delayed(const Duration(microseconds: 10));

    int startTime = 0;
    int endTime = 0;

    while (false == false) {
      startTime = DateTime.now().microsecondsSinceEpoch;
    }

    while (false == true) {
      endTime = DateTime.now().microsecondsSinceEpoch;
    }

    int duracao = endTime - startTime;
    double distancia = duracao / 58.0;
    return distancia;
  }
}

// Classe do robô que utiliza sensores ultrassônicos
class RoboTriangular {
  static const double distanciaMinimaDefault = 25.0;
  final SensorUltrassonico sensorFrente;
  final SensorUltrassonico sensorEsquerda;
  final SensorUltrassonico sensorDireita;

  RoboTriangular(this.sensorFrente, this.sensorEsquerda, this.sensorDireita);

  void parar() {
    if (kDebugMode) {
      print("Robo parado.");
    }
  }

  void darRe() {
    if (kDebugMode) {
      print("Dando ré...");
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

  Future<void> monitorarSensores() async {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      // Carrega distância mínima de desvio do JSON
      double distanciaMinima = await carregaDistanciaMinima();

      double distanciaFrente = await sensorFrente.medirDistancia();
      double distanciaEsquerda = await sensorEsquerda.medirDistancia();
      double distanciaDireita = await sensorDireita.medirDistancia();

      if (kDebugMode) {
        print(
            "Distâncias: Frente: $distanciaFrente cm, Esquerda: $distanciaEsquerda cm, Direita: $distanciaDireita cm");
      }

      if (distanciaFrente < distanciaMinima) {
        parar();
        darRe();
        girarDireita();
      } else if (distanciaEsquerda < distanciaMinima) {
        parar();
        darRe();
        girarDireita();
      } else if (distanciaDireita < distanciaMinima) {
        parar();
        darRe();
        girarEsquerda();
      }
    });
  }

  Future<double> carregaDistanciaMinima() async {
    var distanciaMinima =
        await carregaInfoJson('sensores', 'sensor1', 'distancia_minima');
    return distanciaMinima ?? distanciaMinimaDefault;
  }
}

// Interface Flutter para configurar sensores
class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  late Future<List<String>> rotinasNoDiretorio;
  String? sensor1Diretorio;
  int? sensor1DistanciaMinima;

  @override
  void initState() {
    super.initState();
    rotinasNoDiretorio = listarArquivosJsonSensores();
    carregaInfoJson('sensores', 'sensor1', 'diretorio').then((value) {
      setState(() {
        sensor1Diretorio = value as String?;
      });
    });
    carregaInfoJson('sensores', 'sensor1', 'distancia_minima').then((value) {
      setState(() {
        sensor1DistanciaMinima = value as int?;
      });
      if (kDebugMode) {
        print(sensor1DistanciaMinima);
        print(sensor1Diretorio);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: rotinasNoDiretorio,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar arquivos');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Nenhum arquivo encontrado');
        } else {
          return const Column(
            children: [
              SensorRotina(
                objetoSensor: 'sensor1',
              ),
            ],
          );
        }
      },
    );
  }
}

void main() {
  var sensorFrente = SensorUltrassonico(17, 18);
  var sensorEsquerda = SensorUltrassonico(22, 23);
  var sensorDireita = SensorUltrassonico(24, 25);

  var robo = RoboTriangular(sensorFrente, sensorEsquerda, sensorDireita);
  robo.monitorarSensores();
}
