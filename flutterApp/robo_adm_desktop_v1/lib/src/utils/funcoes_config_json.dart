import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<List<String>> listarArquivosJsonSensores() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String diretorioFinalCaminho = '${diretorio.path}/Rotinas Robo';
  final Directory diretorioFinal = Directory(diretorioFinalCaminho);
  final List<FileSystemEntity> arquivos = diretorioFinal.listSync();

  return arquivos
      .whereType<File>()
      .map((file) => p.basename(file.path))
      .toList();
}

Future<void> carregarConfigSensor(
    String sensor, Function(String?, int?) callback) async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String caminho = '${documentsDirectory.path}/Rotinas Robo/config.json';
  final File configFile = File(caminho);

  if (await configFile.exists()) {
    String conteudo = await configFile.readAsString();
    Map<String, dynamic> json = jsonDecode(conteudo);

    for (var sensorData in json['sensores']) {
      if (sensorData['sensor'] == sensor) {
        callback(sensorData['diretorio'], sensorData['distancia_minima']);
        break;
      }
    }
  }
}

Future<void> atualizarConfigJsonSensores(String sensor,
    {int? novaDistancia = 100, String? novoDiretorio}) async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String caminho = '${documentsDirectory.path}/Rotinas Robo/config.json';
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

Future<List<String>> listaObjJson(String objetoJson, String? chave) async {
  // Pegar o diretório
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String caminhoArquivo =
      '${diretorio.path}/Rotinas Robo/$objetoJson.json';
  final File arquivoJson = File(caminhoArquivo);

  // Verificar se o arquivo existe
  if (!await arquivoJson.exists()) {
    throw Exception('Arquivo JSON não encontrado');
  }

  // Ler o conteúdo do arquivo
  String conteudo = await arquivoJson.readAsString();
  Map<String, dynamic> jsonData = jsonDecode(conteudo);

  // Verifica se a chave é fornecida ou não
  if (chave != null && jsonData.containsKey(chave)) {
    // Se a chave for encontrada, retornar a lista de valores da chave
    var valores = jsonData[chave];

    if (valores is List) {
      // Retornar uma lista de strings se for uma lista no JSON
      return valores.map((item) => item.toString()).toList();
    } else {
      // Se não for uma lista, retornamos o valor convertido em string
      return [valores.toString()];
    }
  } else {
    // Se nenhuma chave for fornecida ou não existir no JSON,
    // retornar todas as chaves do objeto principal
    return jsonData.keys.map((key) => key.toString()).toList();
  }
}

Future<void> atualizarConfigJsonAutomacao(
    String campo, String novaPorta) async {}
