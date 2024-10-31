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

// Classe do robô que utiliza 12 sensores ultrassônicos em posições específicas
class RoboTriangular {
  static const double distanciaMinimaDefault = 25.0;

  // Lista de sensores, com 12 sensores ultrassônicos em posições diferentes
  final List<SensorUltrassonico> sensores;

  RoboTriangular(this.sensores);

  void parar() {
    if (kDebugMode) {
      print("Robô parado.");
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

      // Medir a distância em cada sensor e armazenar em uma lista
      List<double> distancias = await Future.wait(
          sensores.map((sensor) => sensor.medirDistancia()).toList());

      if (kDebugMode) {
        for (int i = 0; i < distancias.length; i++) {
          print("Distância do Sensor $i: ${distancias[i]} cm");
        }
      }

      // Exemplo de lógica simples baseada em distâncias dos sensores
      if (distancias[0] < distanciaMinima || distancias[1] < distanciaMinima) {
        // Sensores na frente detectam obstáculo
        parar();
        darRe();
        girarDireita();
      } else if (distancias[3] < distanciaMinima || distancias[4] < distanciaMinima) {
        // Sensores da esquerda detectam obstáculo
        parar();
        darRe();
        girarDireita();
      } else if (distancias[8] < distanciaMinima || distancias[9] < distanciaMinima) {
        // Sensores da direita detectam obstáculo
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
  // Criação de 12 sensores simulando as posições da imagem
  var sensores = [
    SensorUltrassonico(17, 18), // Sensor 0: Frente
    SensorUltrassonico(19, 20), // Sensor 1: Frente-Direita
    SensorUltrassonico(21, 22), // Sensor 2: Direita
    SensorUltrassonico(23, 24), // Sensor 3: Direita-Traseira
    SensorUltrassonico(25, 26), // Sensor 4: Traseira
    SensorUltrassonico(27, 28), // Sensor 5: Traseira-Esquerda
    SensorUltrassonico(29, 30), // Sensor 6: Esquerda
    SensorUltrassonico(31, 32), // Sensor 7: Esquerda-Frente
    SensorUltrassonico(33, 34), // Sensor 8: Centro-Frente
    SensorUltrassonico(35, 36), // Sensor 9: Centro-Direita
    SensorUltrassonico(37, 38), // Sensor 10: Centro-Esquerda
    SensorUltrassonico(39, 40), // Sensor 11: Centro-Traseira
  ];

  var robo = RoboTriangular(sensores);
  robo.monitorarSensores();
}
