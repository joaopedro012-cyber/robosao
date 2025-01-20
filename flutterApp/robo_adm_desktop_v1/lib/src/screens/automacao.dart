import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';
import 'package:path_provider/path_provider.dart';

// Função para listar os arquivos de rotinas exportadas
Future<List<File>> listarRotinasExportadas() async {
  final Directory diretorio = await getApplicationDocumentsDirectory();
  final String caminhoRotinasExportadas =
      '${diretorio.path}/Rotinas Exportadas';
  final Directory diretorioRotinas = Directory(caminhoRotinasExportadas);

  if (await diretorioRotinas.exists()) {
    final List<FileSystemEntity> arquivos = diretorioRotinas.listSync();
    return arquivos.whereType<File>().toList();
  } else {
    return [];
  }
}

// Função para carregar uma rotina exportada (em formato JSON)
Future<Map<String, dynamic>> carregarRotinaExportada(
    String caminhoArquivo) async {
  final File rotinaExportada = File(caminhoArquivo);
  if (await rotinaExportada.exists()) {
    String conteudo = await rotinaExportada.readAsString();
    return jsonDecode(conteudo); // Retorna os dados da rotina como Map
  } else {
    throw Exception('Arquivo de rotina exportada não encontrado');
  }
}

class AutomacaoPage extends StatefulWidget {
  const AutomacaoPage({super.key});

  @override
  State<AutomacaoPage> createState() => _AutomacaoPageState();
}

class _AutomacaoPageState extends State<AutomacaoPage> {
  late SerialPort porta;
  List<Map<String, dynamic>> rotinasCarregadas = []; // Armazenará as rotinas
  bool conexaoAtiva = false;
  Map<String, String> configuracoesPortas = {
    'Sensores': '',
    'Motores Horizontal': '',
    'Motores Vertical': '',
    'Plataforma': '',
    'Botões Plataforma': '',
    'Botão Roda Dianteira': '',
  };

  @override
  void dispose() {
    if (conexaoAtiva) finalizacaoSerialPort(porta); // Fecha a conexão ao sair
    super.dispose();
  }

  // Função para carregar as rotinas exportadas

  // Função para conectar às portas configuradas
  void iniciarConexao() {
    try {
      setState(() {
        porta = SerialPort(configuracoesPortas['Sensores']!);
        inicializadorSerialPort(porta);
        conexaoAtiva = true;
      });
      if (kDebugMode) print('Conexão iniciada com as portas configuradas.');

      // Exibe a mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conectado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (kDebugMode) print('Erro ao iniciar conexão: $e');
    }
  }

  // Função para desconectar
  void fecharConexao() {
    try {
      if (conexaoAtiva) {
        finalizacaoSerialPort(porta);
        setState(() {
          conexaoAtiva = false;
        });
        if (kDebugMode) print('Conexão fechada.');
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao fechar conexão: $e');
    }
  }

  // Função para executar uma rotina carregada
  void executarRotina(Map<String, dynamic> rotina) {
    if (!conexaoAtiva) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conexão não estabelecida. Conecte-se à porta primeiro.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (rotina['acoes'] != null && rotina['acoes'] is List) {
      for (var acao in rotina['acoes']) {
        final comando = acao['comando'];
        final duracao = acao['duracao'];

        print("Executando comando: $comando por $duracao ms");

        // Simula o envio do comando ao robô
        // Substituir pelo envio real via Bluetooth, por exemplo: bluetooth.send(comando);
        Future.delayed(Duration(milliseconds: duracao), () {
          print("Comando $comando concluído");
        });
      }
    } else {
      print("Formato de rotina inválido. 'acoes' não encontrado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth * 0.35;

    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            verticalDirection: VerticalDirection.down,
            children: configuracoesPortas.keys.map((objetoAutomacao) {
              return Container(
                width: itemWidth,
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$objetoAutomacao:'),
                    TextField(
                      onChanged: (value) {
                        configuracoesPortas[objetoAutomacao] = value;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Porta para $objetoAutomacao',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                // Chama a função iniciarConexao para conectar as portas
                onPressed: iniciarConexao,
                child: const Text('Iniciar Conexão'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                // Chama a função fecharConexao para desconectar as portas
                onPressed: fecharConexao,
                child: const Text('Fechar Conexão'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rotinas Exportadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (var rotina in rotinasCarregadas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Chama a função para executar a rotina quando o botão for pressionado
                        executarRotina(rotina);
                      },
                      child: Text('Executar Rotina ${rotina['nome']}'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
