import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CriadorConfig {
  Future<void> criarConfigJson() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String novoCaminho = '${documentsDirectory.path}/Rotinas Robo';
    final Directory novoDiretorio = Directory(novoCaminho);

    if (!await novoDiretorio.exists()) {
      await novoDiretorio.create(recursive: true);
    }

    final File configFile = File('${novoDiretorio.path}/config.json');
    if (!await configFile.exists()) {
      await configFile.writeAsString('''
        {
  "sensores": [
    {
      "sensor": "sensor1",
      "diretorio": "caminho/para/sensor1",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor2",
      "diretorio": "caminho/para/sensor2",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor3",
      "diretorio": "caminho/para/sensor3",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor4",
      "diretorio": "caminho/para/sensor4",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor5",
      "diretorio": "caminho/para/sensor5",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor6",
      "diretorio": "caminho/para/sensor6",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor7",
      "diretorio": "caminho/para/sensor7",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor8",
      "diretorio": "caminho/para/sensor8",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor9",
      "diretorio": "caminho/para/sensor9",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor10",
      "diretorio": "caminho/para/sensor10",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor11",
      "diretorio": "caminho/para/sensor11",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor12",
      "diretorio": "caminho/para/sensor12",
      "distancia_minima": 10
    }
  ],
  "automacao": [
    {
      "arduino": "Sensores",
      "porta": "COM1"
    },
    {
      "arduino": "Motores Horizontal",
      "porta": "COM2"
    },
    {
      "arduino": "Motores Vertical",
      "porta": "COM3"
    },
  ]
}
''');
    }
  }
}
