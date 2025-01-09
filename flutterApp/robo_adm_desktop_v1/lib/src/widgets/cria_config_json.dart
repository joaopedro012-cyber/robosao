import 'dart:io'; 
import 'package:path_provider/path_provider.dart';

class CriadorConfig {
  /// Função para criar o arquivo config.json com valores padrão
  Future<void> criarConfigJson() async {
    try {
      // Obtém o diretório de documentos do dispositivo
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print('Diretório de documentos: ${documentsDirectory.path}');

      // Define o caminho para a pasta onde o config.json será salvo
      final String novoCaminho = '${documentsDirectory.path}/Rotinas_Robo';
      final Directory novoDiretorio = Directory(novoCaminho);

      // Cria o diretório se ele não existir
      if (!await novoDiretorio.exists()) {
        print('Criando o diretório: $novoCaminho');
        await novoDiretorio.create(recursive: true);
      } else {
        print('Diretório já existe: $novoCaminho');
      }

      // Define o caminho para o arquivo config.json
      final File configFile = File('${novoDiretorio.path}/config.json');

      // Verifica se o arquivo config.json já existe
      if (!await configFile.exists()) {
        // Conteúdo do arquivo config.json
        const String conteudoPadrao = r'''
{
    "sensores": [
        { "nome": "sensor1", "diretorio": "teste.json", "distancia_minima": 87 },
        { "nome": "sensor2", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor3", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor4", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor5", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor6", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor7", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor8", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor9", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor10", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor11", "diretorio": "123teste4.json", "distancia_minima": 145 },
        { "nome": "sensor12", "diretorio": "123teste4.json", "distancia_minima": 145 }
    ],
    "automacao": [
        { "nome": "Sensores", "porta": "COM1234561", "ativo": true },
        { "nome": "Motores Horizontal", "porta": "COM999", "ativo": true },
        { "nome": "Motores Vertical", "porta": "COM3", "ativo": true },
        { "nome": "Plataforma", "porta": "COM3", "ativo": true },
        { "nome": "Botões Plataforma", "porta": "COM3", "ativo": true },
        { "nome": "Botão Roda Dianteira", "porta": "COM3", "ativo": true },
        { "nome": "Monitor Serial Padrao", "porta": "COM4", "ativo": true }
    ]
}
''';

        // Cria o arquivo config.json com o conteúdo padrão
        print('Criando o arquivo config.json em: ${configFile.path}');
        await configFile.writeAsString(conteudoPadrao);
        print('Arquivo config.json criado com sucesso!');
      } else {
        print('O arquivo config.json já existe no caminho: ${configFile.path}');
      }
    } catch (e) {
      print('Erro ao criar o arquivo config.json: $e');
    }
  }

  // Função para verificar se o arquivo de configuração existe
  Future<bool> verificarArquivoConfig() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String novoCaminho = '${documentsDirectory.path}/Rotinas_Robo';
    final Directory novoDiretorio = Directory(novoCaminho);
    final File configFile = File('${novoDiretorio.path}/config.json');
    return await configFile.exists();
  }
}
