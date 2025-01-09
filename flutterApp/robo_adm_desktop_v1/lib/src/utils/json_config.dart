import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Função para carregar o arquivo JSON
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await verificarEDiretorio(); // Garante que o diretório e o arquivo existam
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robô Administrativo Desktop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RoboAdmPage(),
    );
  }
}

class RoboAdmPage extends StatelessWidget {
  const RoboAdmPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robô Administrativo Desktop'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sensores', style: Theme.of(context).textTheme.titleLarge),
              _buildCircularLoadingCard('Motores Horizontal'),
              _buildCircularLoadingCard('Motores Vertical'),
              _buildCircularLoadingCard('Plataforma'),
              _buildCircularLoadingCard('Botões Plataforma'),
              _buildCircularLoadingCard('Botão Roda Dianteira'),
              const SizedBox(height: 20),
              Text('Rotinas Exportadas',
                  style: Theme.of(context).textTheme.titleLarge),
              _buildCircularLoadingCard('Monitor Serial Padrão'),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // Fechar conexão lógica
                  },
                  child: const Text('FECHAR CONEXÃO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método modificado para alternar o indicador com base na plataforma
  Widget _buildCircularLoadingCard(String label) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: _isDesktop()
            ? const SizedBox() // No desktop, não exibe o CircularProgressIndicator
            : const CircularProgressIndicator(), // No mobile, exibe o CircularProgressIndicator
      ),
    );
  }

  bool _isDesktop() {
    return Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS; // Verifica se é desktop
  }
}

// Garante que o diretório e o arquivo existam
Future<void> verificarEDiretorio() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String caminhoDiretorio = '${diretorio.path}/Rotinas Robo';
  final Directory diretorioFinal = Directory(caminhoDiretorio);
  if (!await diretorioFinal.exists()) {
    await diretorioFinal.create(recursive: true);
    print('Diretório criado: $caminhoDiretorio');
  }
  final File configJson = File('$caminhoDiretorio/config.json');
  if (!await configJson.exists()) {
    await configJson.writeAsString(jsonEncode({"sensores": [], "rotinas": []}));
    print('Arquivo config.json criado com conteúdo padrão.');
  }
}

// Código para carregar arquivos JSON com validação
Future<Map<String, dynamic>> carregaConfigJson() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final File configJson = File('${diretorio.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    try {
      return jsonDecode(conteudo); // Retorna o conteúdo como Map
    } catch (e) {
      print('Erro ao decodificar JSON: $e');
      // Recria o arquivo em caso de erro no formato JSON
      final novoConteudo = {"sensores": [], "rotinas": []};
      await configJson.writeAsString(jsonEncode(novoConteudo), flush: true);
      print('Arquivo JSON recriado com conteúdo padrão.');
      return novoConteudo;
    }
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
    final List<FileSystemEntity> arquivos =
        diretorioFinal.listSync().where((entity) => path.extension(entity.path) == '.json').toList();
    return arquivos.map((e) => path.basename(e.path)).toList();
  } else {
    throw Exception('Diretório de sensores não encontrado');
  }
}

// Função para atualizar uma propriedade no JSON
Future<void> atualizaJson(
    String secao, String objeto, String propriedade, dynamic novoValor) async {
  final Directory diretorioDocumentos =
      await getApplicationDocumentsDirectory();
  final File configJson = File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    var json = jsonDecode(conteudo);

    if (json.containsKey(secao)) {
      bool atualizado = false;

      // Buscar pela seção e objeto
      for (var item in json[secao]) {
        if (item['nome'] == objeto) {
          // Validação de tipo e atribuição do novo valor
          if (propriedade == 'distancia_minima' && novoValor is! int) {
            novoValor = int.tryParse(novoValor.toString()) ?? 1234; // Default para 1234 se não for um int válido
          } else if (propriedade != 'distancia_minima' && novoValor is! String) {
            novoValor = novoValor.toString(); // Converte para String
          }
          // Atualiza o valor da propriedade
          print('Atualizando $secao -> $objeto -> $propriedade para $novoValor');
          item[propriedade] = novoValor;
          atualizado = true;
          break;
        }
      }

      if (atualizado) {
        // Grava o arquivo de volta
        await configJson.writeAsString(jsonEncode(json), flush: true);
        print('Atualização concluída com sucesso.');
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
  final File configJson = File('${diretorioDocumentos.path}/Rotinas Robo/config.json');

  if (await configJson.exists()) {
    String conteudo = await configJson.readAsString();
    var json = jsonDecode(conteudo);

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
