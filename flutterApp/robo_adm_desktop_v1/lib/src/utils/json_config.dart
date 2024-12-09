import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
      return jsonDecode(conteudo);
    } catch (e) {
      print('Erro ao decodificar JSON: $e');
      // Recria o arquivo em caso de erro no formato JSON
      final novoConteudo = {"sensores": [], "rotinas": []};
      await configJson.writeAsString(jsonEncode(novoConteudo), flush: true);
      print('Arquivo JSON recriado com conteúdo padrão.');
      return novoConteudo;
    }
  } else {
    throw Exception('Arquivo config.json não encontrado.');
  }
}

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

      for (var item in json[secao]) {
        if (item['nome'] == objeto) {
          print(
              'Atualizando $secao -> $objeto -> $propriedade para $novoValor');
          item[propriedade] = novoValor;
          atualizado = true;
          break;
        }
      }

      if (atualizado) {
        await configJson.writeAsString(jsonEncode(json), flush: true);
        print('Atualização concluída com sucesso.');
      } else {
        print('Objeto não encontrado para atualização.');
        throw Exception('Objeto não encontrado para atualização.');
      }
    } else {
      print('Seção não encontrada no JSON.');
      throw Exception('Seção não encontrada no arquivo JSON.');
    }
  } else {
    print('Arquivo config.json não encontrado.');
    throw Exception('Arquivo config.json não encontrado.');
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

    if (json.containsKey(secao)) {
      for (var item in json[secao]) {
        if (item['nome'] == objeto) {
          return item[propriedade];
        }
      }
    } else {
      throw Exception('Seção não encontrada no arquivo JSON.');
    }
  } else {
    throw Exception('Arquivo config.json não encontrado.');
  }
}
