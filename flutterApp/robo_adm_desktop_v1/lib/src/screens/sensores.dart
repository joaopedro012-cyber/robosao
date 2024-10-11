import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/funcoes_config_json.dart';
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
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
    rotinasNoDiretorio = listarArquivosJsonSensores();
    carregaInfoJson('sensores', 'sensor1', 'diretorio').then((value) {
      sensor1Diretorio = value as String?;
    });
    carregaInfoJson('sensores', 'sensor1', 'distancia_minima').then((value) {
      sensor1DistanciaMinima = value as int?;
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
          List<String> rotinas = snapshot.data!;
          return Column(
            children: [
              SensorRotina(
                sensor: 'Sensor 1',
                placeholder: sensor1Diretorio ?? 'Exemplo.json',
                rotinas: rotinas,
                distanciaMinima: sensor1DistanciaMinima,
                onDistanciaChanged: (novoValor) {
                  atualizaJson(
                      'sensores', 'sensor1', 'distancia_minima', novoValor);
                },
                onDiretorioChanged: (novoDiretorio) {
                  atualizaJson(
                      'sensores', 'sensor1', 'diretorio', novoDiretorio);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
