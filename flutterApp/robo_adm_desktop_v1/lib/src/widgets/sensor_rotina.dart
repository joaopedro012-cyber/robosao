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
    carregaInfo();
  }

  Future<void> carregaInfo() async {
    rotinaNoPlaceholder = await carregaInfoJson('sensores', widget.objetoSensor, 'diretorio');
    distanciaMinima = (await carregaInfoJson('sensores', widget.objetoSensor, 'distancia_minima')) as int;
    setState(() {});
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
          debugPrint('Error loading data: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        } else {
          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: screenWidth * 0.05, // Espaçamento horizontal
            runSpacing: screenWidth * 0.02, // Espaçamento vertical
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
                        items: snapshot.data!.map((lista) {
                          return fui.AutoSuggestBoxItem<String>(
                            value: lista,
                            label: lista,
                            onFocusChange: (focused) {
                              if (focused) {
                                debugPrint('Focused $lista');
                              }
                            },
                          );
                        }).toList(),
                        onSelected: (item) async {
                          setState(() => selected = item);
                          await atualizaJson('sensores', widget.objetoSensor, 'diretorio', item.value);
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
                                await atualizaJson(
                                  'sensores',
                                  widget.objetoSensor,
                                  'distancia_minima',
                                  value,
                                );
                                setState(() => distanciaMinima = value as int);

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
