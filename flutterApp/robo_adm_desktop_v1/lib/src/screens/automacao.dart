import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/utils/serial_config.dart';
import 'package:robo_adm_desktop_v1/src/widgets/automacao_campo.dart';
import 'package:robo_adm_desktop_v1/src/widgets/monitor_serial.dart';
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
  List<Map<String, dynamic>> rotinasCarregadas =
      []; // Armazenará as rotinas carregadas

  @override
  void initState() {
    super.initState();
    porta = SerialPort("COM4");
    _carregarRotinasExportadas(); // Carregar rotinas na inicialização
    executarAutomacao(); // Executar a automação ao iniciar a tela
  }

  @override
  void dispose() {
    finalizacaoSerialPort(porta);
    super.dispose();
  }

  // Função para carregar as rotinas exportadas
  Future<void> _carregarRotinasExportadas() async {
    try {
      final List<File> arquivos = await listarRotinasExportadas();
      List<Map<String, dynamic>> rotinas = [];
      for (var arquivo in arquivos) {
        Map<String, dynamic> rotina =
            await carregarRotinaExportada(arquivo.path);
        rotinas.add(rotina);
      }
      setState(() {
        rotinasCarregadas = rotinas;
      });
    } catch (e) {
      print('Erro ao carregar rotinas exportadas: $e');
    }
  }

  // Função para executar a automação das rotinas carregadas
  Future<void> executarAutomacao() async {
    for (var rotina in rotinasCarregadas) {
      await _executarRotina(rotina); // Executa cada rotina automaticamente
    }
  }

  // Função para executar uma rotina específica
  Future<void> _executarRotina(Map<String, dynamic> rotina) async {
    try {
      for (var chave in rotina.keys) {
        var acao = rotina[chave];
        // Implemente a lógica para executar as ações com base na rotina carregada
        print('Executando: $chave - $acao');
        // Exemplo de envio de comando para a porta serial
        enviaDadosSerialPort(porta, "$chave:$acao\n");
        await Future.delayed(const Duration(
            seconds:
                1)); // Aguarda um tempo entre comandos, ajuste conforme necessário
      }
    } catch (e) {
      print('Erro ao executar rotina: $e');
    }
  }

  // Função para construir o campo de automação
  Widget _buildAutomacaoCampo(String objetoAutomacao, double width) {
    return Container(
      width: width,
      alignment: Alignment.topLeft,
      child: AutomacaoCampo(
        objetoAutomacao: objetoAutomacao,
      ),
    );
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
            children: [



              
              // Campos de automação fixos
              _buildAutomacaoCampo('Sensores', itemWidth),
              _buildAutomacaoCampo('Motores Horizontal', itemWidth),
              _buildAutomacaoCampo('Motores Vertical', itemWidth),
              _buildAutomacaoCampo('Plataforma', itemWidth),
              _buildAutomacaoCampo('Botões Plataforma', itemWidth),
              _buildAutomacaoCampo('Botão Roda Dianteira', itemWidth),
            ],
          ),
          // Exibindo as rotinas carregadas
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
                        _executarRotina(
                            rotina); // Executa a rotina selecionada manualmente
                      },
                      child: Text('Executar Rotina ${rotina['nome']}'),
                    ),
                  ),
              ],
            ),
          ),
          // Monitor Serial
          SizedBox(
            width: screenWidth,
            height: screenWidth * 0.15,
            child: Column(
              children: [
                const AutomacaoCampo(
                  objetoAutomacao: 'Monitor Serial Padrao',
                ),
                FilledButton(
                  child: const Text('FECHA A CONEXÃO'),
                  onPressed: () => finalizacaoSerialPort(porta),
                ),
                Container(
                  color: Colors.black,
                  width: screenWidth,
                  child: MonitorSerial(
                    portaConexao: porta,
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
