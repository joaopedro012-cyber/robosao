import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<List<String>> carregaConfigJson() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final Directory documentosRotinasRobo =
      Directory('${diretorio.path}/Rotinas Robo');
  final List<FileSystemEntity> arquivos = documentosRotinasRobo.listSync();

  return arquivos
      .whereType<File>()
      .map((file) => path.basename(file.path))
      .toList();
}

Future<void> atualizaJson(
    String secao, String objeto, String propriedade, dynamic novoValor) async {
  final Directory diretorioDocumentos =
      await getApplicationDocumentsDirectory();
  final File configJson =
      File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    Map<String, dynamic> json = jsonDecode(conteudo);

    for (var secaoJson in json[secao]) {
      if (secaoJson['nome'] == objeto) {
        secaoJson[propriedade] = novoValor;
        break;
      }
    }

    await configJson.writeAsString(jsonEncode(json));
  }
}
