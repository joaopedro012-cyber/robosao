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

    // Lógica de acionamento do sensor
    // Simula o acionamento do trigger (em hardware real seria um pulso digital)
    startTime = DateTime.now().microsecondsSinceEpoch;

    // Simula a leitura do valor do echo (em hardware real seria um valor digital lido)
    // Aqui, para fins de simulação, o valor de endTime é ajustado artificialmente
    await Future.delayed(const Duration(milliseconds: 100)); // Simula o tempo de resposta do sensor
    endTime = DateTime.now().microsecondsSinceEpoch;

    // Calcula a distância com base no tempo de voo do som
    int duracao = endTime - startTime;
    double distancia = duracao / 58.0; // A constante 58 é baseada na velocidade do som
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
      double distanciaMinima = await carregaDistanciaMinima();

      // Medir a distância em cada sensor e armazenar em uma lista
      List<double> distancias = await Future.wait(
        sensores.map((sensor) => sensor.medirDistancia()).toList(),
      );

      if (kDebugMode) {
        for (int i = 0; i < distancias.length; i++) {
          print("Distância do Sensor $i: ${distancias[i]} cm");
        }
      }

      // Verifica se há obstáculos e realiza a movimentação
      _verificaObstaculos(distancias, distanciaMinima);
    });
  }

  void _verificaObstaculos(List<double> distancias, double distanciaMinima) {
    // Se os sensores à frente detectarem um obstáculo
    if (distancias[0] < distanciaMinima ||
        distancias[1] < distanciaMinima ||
        distancias[8] < distanciaMinima ||
        distancias[9] < distanciaMinima) {
      parar();
      moverParaTras();
      girarDireita(); // Gira à direita para evitar o obstáculo
      // Avança após girar para verificar se o caminho está livre
      Future.delayed(const Duration(seconds: 1), () {
        moverParaFrente();
      });
    }
    // Se os sensores laterais detectarem um obstáculo
    else if (distancias[2] < distanciaMinima ||
        distancias[3] < distanciaMinima ||
        distancias[4] < distanciaMinima ||
        distancias[5] < distanciaMinima ||
        distancias[6] < distanciaMinima ||
        distancias[7] < distanciaMinima) {
      parar();
      moverParaTras();
      girarEsquerda(); // Gira à esquerda para evitar o obstáculo
      // Avança após girar para verificar se o caminho está livre
      Future.delayed(const Duration(seconds: 1), () {
        moverParaFrente();
      });
    }
    // Se o centro do robô estiver obstruído
    else if (distancias[10] < distanciaMinima ||
        distancias[11] < distanciaMinima) {
      parar();
      moverParaTras();
      girarDireita(); // Se o centro estiver obstruído, gira para a direita
      // Avança após girar para verificar se o caminho está livre
      Future.delayed(const Duration(seconds: 1), () {
        moverParaFrente();
      });
    } else {
      // Caso não haja obstáculos, segue em frente
      moverParaFrente();
    }
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
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final diretorio = await carregaInfoJson('sensores', 'sensor1', 'diretorio');
    final distanciaMinima =
        await carregaInfoJson('sensores', 'sensor1', 'distancia_minima');

    setState(() {
      sensor1Diretorio = diretorio as String?;
      sensor1DistanciaMinima = distanciaMinima as int?;
    });

    if (kDebugMode) {
      print(sensor1DistanciaMinima);
      print(sensor1Diretorio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: rotinasNoDiretorio,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar arquivos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum arquivo encontrado'));
        } else {
          return const Column(
            children: [
              SensorRotina(objetoSensor: 'sensor1'),
              // Adicione aqui mais elementos que precisam ser exibidos
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
