import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Função para carregar o arquivo JSON
Future<Map<String, dynamic>> carregaConfigJson() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final File configJson = File('${diretorio.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    return jsonDecode(conteudo); // Retorna o conteúdo como Map
  } else {
    throw Exception('Arquivo config.json não encontrado');
  }
}

// Função para listar os arquivos JSON na seção de sensores
Future<List<String>> listarArquivosJsonSensores() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String caminhoDiretorio = '${diretorio.path}/Rotinas Robo';
  final Directory diretorioFinal = Directory(caminhoDiretorio);

  if (await diretorioFinal.exists()) {
    final List<FileSystemEntity> arquivos = diretorioFinal.listSync();
    return arquivos
        .whereType<File>()
        .map((file) => path.basename(file.path))
        .toList();
  } else {
    return [];
  }
}

// Função para atualizar uma propriedade no JSON
Future<void> atualizaJson(
    String secao, String objeto, String propriedade, dynamic novoValor) async {
  final Directory diretorioDocumentos =
      await getApplicationDocumentsDirectory();
  final File configJson =
      File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    Map<String, dynamic> json = jsonDecode(conteudo);

    if (json.containsKey(secao)) {
      bool atualizado = false;

      // Buscar pela seção e objeto
      for (var item in json[secao]) {
        if (item['nome'] == objeto) {
          // Validação de tipo e atribuição do novo valor
          if (propriedade == 'distancia_minima' && novoValor is! int) {
            novoValor = int.tryParse(novoValor.toString()) ??
                1234; // Default para 1234 se não for um int válido
          } else if (propriedade != 'distancia_minima' &&
              novoValor is! String) {
            novoValor = novoValor.toString(); // Converte para String
          }

          // Atualiza o valor da propriedade
          item[propriedade] = novoValor;
          atualizado = true;
          break;
        }
      }

      if (atualizado) {
        // Grava o arquivo de volta
        await configJson.writeAsString(jsonEncode(json), flush: true);
      } else {
        throw Exception('Objeto não encontrado para atualização');
      }
    } else {
      throw Exception('Seção não encontrada no arquivo JSON');
    }
  } else {
    throw Exception('Arquivo config.json não encontrado');
  }
}

// Função para carregar o valor de uma propriedade específica no JSON
Future<dynamic> carregaInfoJson(
    String secao, String objeto, String propriedade) async {
  final Directory diretorioDocumentos =
      await getApplicationDocumentsDirectory();
  final File configJson =
      File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    Map<String, dynamic> json = jsonDecode(conteudo);

    if (json.containsKey(secao)) {
      for (var item in json[secao]) {
        if (item['nome'] == objeto) {
          return item[propriedade]; // Retorna o valor da propriedade
        }
      }
    } else {
      throw Exception('Seção não encontrada no arquivo JSON');
    }
  } else {
    throw Exception('Arquivo config.json não encontrado');
  }
}
