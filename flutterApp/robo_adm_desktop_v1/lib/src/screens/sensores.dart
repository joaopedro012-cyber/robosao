import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:robo_adm_desktop_v1/src/widgets/sensor_rotina.dart';

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
    rotinasNoDiretorio = listarArquivosJson();
    carregarConfigSensor('sensor1');
  }

  Future<List<String>> listarArquivosJson() async {
    final Directory diretorio = await getApplicationDocumentsDirectory();
    final String diretorioFinalCaminho = '${diretorio.path}/Rotinas Robo';
    final Directory diretorioFinal = Directory(diretorioFinalCaminho);
    final List<FileSystemEntity> arquivos = diretorioFinal.listSync();

    return arquivos
        .whereType<File>()
        .map((file) => p.basename(file.path))
        .toList();
  }

  Future<void> carregarConfigSensor(String sensor) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String caminho =
        '${documentsDirectory.path}/Rotinas Robo/config.json';
    final File configFile = File(caminho);

    if (await configFile.exists()) {
      String conteudo = await configFile.readAsString();
      Map<String, dynamic> json = jsonDecode(conteudo);

      for (var sensorData in json['sensores']) {
        if (sensorData['sensor'] == sensor) {
          setState(() {
            sensor1Diretorio = sensorData['diretorio'] ?? 'Exemplo.json';
            sensor1DistanciaMinima = sensorData['distancia_minima'] ?? 100;
          });
          break;
        }
      }
    }
  }

  Future<void> atualizarConfigJson(String sensor,
      {int? novaDistancia = 100, String? novoDiretorio}) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String caminho =
        '${documentsDirectory.path}/Rotinas Robo/config.json';
    final File configFile = File(caminho);

    if (await configFile.exists()) {
      String conteudo = await configFile.readAsString();
      Map<String, dynamic> json = jsonDecode(conteudo);

      for (var sensorData in json['sensores']) {
        if (sensorData['sensor'] == sensor) {
          if (novaDistancia != null) {
            sensorData['distancia_minima'] = novaDistancia;
          }
          if (novoDiretorio != null) {
            sensorData['diretorio'] = novoDiretorio;
          }
          break;
        }
      }

      await configFile.writeAsString(jsonEncode(json));
    }
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
          List<String> rotinas = snapshot.data!;
          return Column(
            children: [
              SensorRotina(
                sensor: 'Sensor 1',
                placeholder: sensor1Diretorio ?? 'Exemplo.json',
                rotinas: rotinas,
                distanciaMinima: sensor1DistanciaMinima,
                onDistanciaChanged: (novoValor) {
                  atualizarConfigJson('sensor1', novaDistancia: novoValor);
                },
                onDiretorioChanged: (novoDiretorio) {
                  atualizarConfigJson('sensor1', novoDiretorio: novoDiretorio);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
