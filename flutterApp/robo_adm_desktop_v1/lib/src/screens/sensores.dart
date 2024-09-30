import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  String? selected;
  String placeholder = 'exemplo.json';
  late Future<List<String>> rotinasNoDiretorio;
  int? distanciaMinima;

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
            placeholder = sensorData['diretorio'] ?? 'Exemplo.json';
            distanciaMinima = sensorData['distancia_minima'] ?? 100;
          });
          break;
        }
      }
    }
  }

  Future<void> atualizarConfigJson(String sensor,
      {int? novaDistancia, String? novoDiretorio}) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String caminho =
        '${documentsDirectory.path}/Rotinas Robo/config.json';
    final File configFile = File(caminho);

    if (await configFile.exists()) {
      // Ler o conteúdo do arquivo
      String conteudo = await configFile.readAsString();
      Map<String, dynamic> json = jsonDecode(conteudo);

      // Encontrar o sensor e atualizar os valores
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

      // Escrever o conteúdo atualizado de volta no arquivo
      await configFile.writeAsString(jsonEncode(json));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int? numberBoxValue = distanciaMinima;
    void _valueChanged(int? newValue) {
      setState(() {
        numberBoxValue = newValue;
      });
    }

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
          return Wrap(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Sensor 1'),
              SizedBox(
                width: screenWidth * 0.35,
                child: Wrap(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.27,
                      child: fui.AutoSuggestBox<String>(
                        placeholder: placeholder,
                        items: rotinas.map((rotina) {
                          return fui.AutoSuggestBoxItem<String>(
                            value: rotina,
                            label: rotina,
                            onFocusChange: (focused) {
                              if (focused) {
                                debugPrint('Focused $rotina');
                              }
                            },
                          );
                        }).toList(),
                        onSelected: (item) {
                          setState(() => selected = item.value);
                          atualizarConfigJson('sensor1',
                              novoDiretorio: item.value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth * 0.25,
                child: fui.NumberBox(
                  value: numberBoxValue,
                  onChanged: (novoValor) {
                    setState(() {
                      numberBoxValue = novoValor;
                    });
                    atualizarConfigJson('sensor1', novaDistancia: novoValor);
                  },
                  mode: fui.SpinButtonPlacementMode.inline,
                ),
              ),
              const Text('cm'),
            ],
          );
        }
      },
    );
  }
}
