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
  late Future<List<String>> rotinasNoDiretorio;

  @override
  void initState() {
    super.initState();
    rotinasNoDiretorio = listarArquivosJson();
  }

  Future<List<String>> listarArquivosJson() async {
    final Directory diretorio = await getApplicationDocumentsDirectory();
    final String diretorioFinalCaminho = '${diretorio.path}/Rotinas Robo';
    final Directory diretorioFinal = Directory(diretorioFinalCaminho);
    final List<FileSystemEntity> arquivos = diretorioFinal.listSync();
    double screenWidth = MediaQuery.of(context).size.width;

    return arquivos
        .whereType<File>()
        .map((file) => p.basename(file.path))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int? numberBoxValue = 100;
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
                        placeholder: 'Exemplo.json',
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth * 0.20,
                child: fui.NumberBox(
                  value: numberBoxValue,
                  onChanged: _valueChanged,
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
