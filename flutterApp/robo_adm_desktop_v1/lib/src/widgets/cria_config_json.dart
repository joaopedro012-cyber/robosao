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
            "nome": "sensor1",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor2",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor3",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor4",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor5",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor6",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor7",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor8",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor9",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor10",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor11",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        },
        {
            "nome": "sensor12",
            "diretorio": "123teste4.json",
            "distancia_minima": 145
        }
    ],
    "automacao": [
        {
            "nome": "Sensores",
            "porta": "com1234561"
        },
        {
            "nome": "Motores Horizontal",
            "porta": "COM999"
        },
        {
            "nome": "Motores Vertical",
            "porta": "COM3"
        },
        {
            "nome": "Plataforma",
            "porta": "COM3"
        },
        {
            "nome": "Botões Plataforma",
            "porta": "COM3"
        },
        {
            "nome": "Botão Roda Dianteira",
            "porta": "COM3"
        }
    ]
}
''');
    }
  }
}
