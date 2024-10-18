import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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

Future<List<String>> listarArquivosJsonSensores() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String diretorioFinalCaminho = '${diretorio.path}/Rotinas Robo';
  final Directory diretorioFinal = Directory(diretorioFinalCaminho);
  final List<FileSystemEntity> arquivos = diretorioFinal.listSync();

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

    if (secao == 'sensores' && propriedade == 'distancia_minima') {
      for (var secaoJson in json[secao]) {
        if (secaoJson['nome'] == objeto) {
          if (novoValor == null) {
            novoValor = 1234;
          } else if (novoValor is! int) {
            novoValor = int.parse(novoValor);
          }
          secaoJson[propriedade] = novoValor;
          break;
        }
      }
    } else {
      for (var secaoJson in json[secao]) {
        if (secaoJson['nome'] == objeto) {
          if (novoValor == null) {
            novoValor = 'SEM ARQUIVO SELECIONADO';
          } else if (novoValor is! String) {
            novoValor = (novoValor).toString();
          }
          secaoJson[propriedade] = novoValor;
          break;
        }
      }
    }
    await configJson.writeAsString(jsonEncode(json));
  }
}

Future<dynamic> carregaInfoJson(
    String secao, String objeto, String propriedade) async {
  final Directory diretorioDocumentos =
      await getApplicationDocumentsDirectory();
  final File configJson =
      File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    Map<String, dynamic> json = jsonDecode(conteudo);

    for (var secaoJson in json[secao]) {
      if (secaoJson['nome'] == objeto) {
        if (kDebugMode) {
          print('testeL ${secaoJson[propriedade]}');
        }
        return (secaoJson[propriedade]);
      }
    }
  }
  return null;
}
