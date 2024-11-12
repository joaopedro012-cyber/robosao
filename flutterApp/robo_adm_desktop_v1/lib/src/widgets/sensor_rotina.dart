import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';

Future<List<String>> objetoListaDeRotinas = listarArquivosJsonSensores();

class SensorRotina extends StatefulWidget {
  final String objetoSensor;
  const SensorRotina({super.key, required this.objetoSensor});

  @override
  SensorRotinaState createState() => SensorRotinaState();
}

class SensorRotinaState extends State<SensorRotina> {
  fui.AutoSuggestBoxItem<String>? selected;
  String rotinaNoPlaceholder = '';
  int distanciaMinima = 0;
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    _carregaInfo();
  }

  // Função para carregar as informações do sensor do config.json
  Future<void> _carregaInfo() async {
    try {
      rotinaNoPlaceholder =
          await carregaInfoJson('sensores', widget.objetoSensor, 'diretorio') ??
              '';
      distanciaMinima = (await carregaInfoJson(
              'sensores', widget.objetoSensor, 'distancia_minima') ??
          0) as int;

      if (mounted) {
        // Verificar se o widget está montado antes de chamar setState
        setState(() {});
      }
    } catch (e) {
      debugPrint('Erro ao carregar informações do JSON: $e');
    }
  }

  // Atualizar a distância mínima no config.json
  Future<void> _atualizarDistancia(int valor) async {
    await atualizaJson(
        'sensores', widget.objetoSensor, 'distancia_minima', valor);
    if (mounted) {
      setState(() => distanciaMinima = valor);
    }
  }

  // Atualizar o diretório no config.json
  Future<void> _atualizarDiretorio(String? valor) async {
    if (valor != null) {
      await atualizaJson('sensores', widget.objetoSensor, 'diretorio', valor);
      if (mounted) {
        setState(() => rotinaNoPlaceholder = valor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<String>>(
      future: objetoListaDeRotinas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          debugPrint('Erro ao carregar dados: ${snapshot.error}');
          return Text('Erro: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Nenhum dado disponível');
        } else {
          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: screenWidth * 0.05,
            runSpacing: screenWidth * 0.02,
            children: [
              SizedBox(
                width: screenWidth * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.objetoSensor),
                    SizedBox(
                      width: screenWidth * 0.30,
                      child: fui.AutoSuggestBox<String>(
                        placeholder: rotinaNoPlaceholder,
                        items: snapshot.data!.map((item) {
                          return fui.AutoSuggestBoxItem<String>(
                            value: item,
                            label: item,
                            onFocusChange: (focused) {
                              if (focused) debugPrint('Focado em $item');
                            },
                          );
                        }).toList(),
                        onSelected: (item) async {
                          setState(() => selected = item);
                          await _atualizarDiretorio(item.value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Distância Mínima'),
                    SizedBox(
                      width: screenWidth * 0.10,
                      child: fui.NumberBox(
                        value: distanciaMinima,
                        min: 0,
                        max: 200,
                        onChanged: disabled
                            ? null
                            : (value) async {
                                if (value is int) {
                                  await _atualizarDistancia(value);
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
