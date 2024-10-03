import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/widgets/sensor_rotina.dart';
import 'package:robo_adm_desktop_v1/src/utils/funcoes_config_json.dart';

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
    carregarConfigSensor('sensor1', (diretorio, distanciaMinima) {
      setState(() {
        sensor1Diretorio = diretorio ?? 'Exemplo.json';
        sensor1DistanciaMinima = distanciaMinima ?? 100;
      });
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
                  atualizarConfigJsonSensores('sensor1',
                      novaDistancia: novoValor);
                },
                onDiretorioChanged: (novoDiretorio) {
                  atualizarConfigJsonSensores('sensor1',
                      novoDiretorio: novoDiretorio);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
