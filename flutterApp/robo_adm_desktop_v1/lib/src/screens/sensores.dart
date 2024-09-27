import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
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

    return arquivos.where((file) => file is File).map((file) => file.path).toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<String>>(
      future: rotinasNoDiretorio,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar arquivos');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhum arquivo encontrado');
        } else {
          List<String> rotinas = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: screenWidth * 0.35,
                child: Wrap(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.27,
                      child: fui.AutoSuggestBox<String>(
                        placeholder: 'Rotinas',
                        items: rotinas.map((cat) {
                          return fui.AutoSuggestBoxItem<String>(
                            value: cat,
                            label: cat,
                            onFocusChange: (focused) {
                              if (focused) {
                                debugPrint('Focused $cat');
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
            ],
          );
        }
      },
    );
  }
}
