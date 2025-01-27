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
  final String caminhoRotinasExportadas = '${diretorio.path}/Rotinas Exportadas';  
  final Directory diretorioRotinas = Directory(caminhoRotinasExportadas);  

  if (await diretorioRotinas.exists()) {  
    final List<FileSystemEntity> arquivos = diretorioRotinas.listSync();  
    return arquivos.whereType<File>().toList();  
  } else {  
    return [];  
  }  
}  

// Função para carregar uma rotina exportada (em formato JSON)
Future<Map<String, dynamic>> carregarRotinaExportada(String caminhoArquivo) async {  
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
  List<Map<String, dynamic>> rotinasCarregadas = [];  
  bool conexaoAtiva = false;  
  Map<String, String?> configuracoesPortas = {  
    'Sensores': null,  
    'Motores Horizontal': null,  
    'Motores Vertical': null,  
    'Plataforma': null,  
    'Botões Plataforma': null,  
    'Botão Roda Dianteira': null,  
  };  

  Map<String, bool> statusConexao = {  
    'Sensores': false,  
    'Motores Horizontal': false,  
    'Motores Vertical': false,  
    'Plataforma': false,  
    'Botões Plataforma': false,  
    'Botão Roda Dianteira': false,  
  };  

  List<String> portasDisponiveis = [];  

  @override  
  void initState() {  
    super.initState();  
    _listarPortasDisponiveis();  
  }  

  // Função para listar as portas COM disponíveis
  void _listarPortasDisponiveis() {  
    final listaPortas = SerialPort.availablePorts;  
    setState(() {  
      portasDisponiveis = listaPortas;  
    });  
  }  

  @override  
  void dispose() {  
    if (conexaoAtiva) finalizacaoSerialPort(porta); // Fecha a conexão ao sair  
    super.dispose();  
  }  

  // Função para conectar às portas configuradas
  void iniciarConexao() {  
    try {  
      setState(() {  
        // Verifica se a porta 'Sensores' está configurada corretamente  
        if (configuracoesPortas['Sensores'] != null && configuracoesPortas['Sensores']!.isNotEmpty) {  
          porta = SerialPort(configuracoesPortas['Sensores']!);  
          inicializadorSerialPort(porta);  
          conexaoAtiva = true;  

          // Atualiza o status de conexão de cada porta configurada  
          configuracoesPortas.forEach((key, value) {  
            if (value != null && value.isNotEmpty) {  
              statusConexao[key] = true; // Marca como conectado  
            }  
          });  
        } else {  
          // Caso a porta não esteja configurada corretamente, não faz a conexão  
          if (mounted) {  
            ScaffoldMessenger.of(context).showSnackBar(  
              const SnackBar(  
                content: Text('Por favor, selecione todas as portas COM antes de conectar.'),  
                duration: Duration(seconds: 2),  
              ),  
            );  
          }  
        }  
      });  

      if (mounted) {  
        ScaffoldMessenger.of(context).showSnackBar(  
          const SnackBar(  
            content: Text('Conectado com sucesso!'),  
            duration: Duration(seconds: 2),  
          ),  
        );  
      }  
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

          // Marca todas as conexões como inativas  
          statusConexao.updateAll((key, value) => false);  
        });  
        if (mounted) {  
          ScaffoldMessenger.of(context).showSnackBar(  
            const SnackBar(  
              content: Text('Conexão fechada.'),  
              duration: Duration(seconds: 2),  
            ),  
          );  
        }  
      }  
    } catch (e) {  
      if (kDebugMode) print('Erro ao fechar conexão: $e');  
    }  
  }  

  // Função para executar uma rotina carregada
  void executarRotina(Map<String, dynamic> rotina) {  
    if (!conexaoAtiva) {  
      if (mounted) {  
        ScaffoldMessenger.of(context).showSnackBar(  
          const SnackBar(  
            content: Text('Conexão não estabelecida. Conecte-se à porta primeiro.'),  
            duration: Duration(seconds: 2),  
          ),  
        );  
      }  
      return;  
    }  

    if (rotina['acoes'] != null && rotina['acoes'] is List) {  
      for (var acao in rotina['acoes']) {  
        final comando = acao['comando'];  
        final duracao = acao['duracao'];  

        print("Executando comando: $comando por $duracao ms");  

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
    return Scaffold(  
      appBar: AppBar(  
        title: const Text('Automação de Robô'),  
        centerTitle: true,  
      ),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: SingleChildScrollView(  
          child: Column(  
            children: [  
              // Lista de Configurações de Portas  
              GridView.builder(  
                shrinkWrap: true,  
                physics: const NeverScrollableScrollPhysics(),  
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(  
                  crossAxisCount: 3,  
                  crossAxisSpacing: 16.0,  
                  mainAxisSpacing: 16.0,  
                  childAspectRatio: 3 / 2,  
                ),  
                itemCount: configuracoesPortas.keys.length,  
                itemBuilder: (context, index) {  
                  String objetoAutomacao = configuracoesPortas.keys.elementAt(index);  

                  return Container(  
                    decoration: BoxDecoration(  
                      color: Colors.grey[100],  
                      borderRadius: BorderRadius.circular(8.0),  
                      boxShadow: const [  
                        BoxShadow(  
                          color: Colors.black12,  
                          blurRadius: 8.0,  
                          offset: Offset(0, 4),  
                        ),  
                      ],  
                    ),  
                    padding: const EdgeInsets.all(8.0),  
                    child: Column(  
                      crossAxisAlignment: CrossAxisAlignment.start,  
                      children: [  
                        Text('$objetoAutomacao:', style: Theme.of(context).textTheme.titleLarge),  
                        DropdownButton<String>(  
                          value: configuracoesPortas[objetoAutomacao],  
                          onChanged: (novaPorta) {  
                            setState(() {  
                              configuracoesPortas[objetoAutomacao] = novaPorta;  
                            });  
                          },  
                          hint: const Text('Selecione a porta'),  
                          items: portasDisponiveis.isEmpty  
                              ? [  
                                  const DropdownMenuItem<String>(  
                                    value: null,  
                                    child: Text('Nenhuma porta disponível'),  
                                  )  
                                ]  
                              : [  
                                  const DropdownMenuItem<String>(  
                                    value: null,  
                                    child: Text('Nenhuma porta selecionada'),  
                                  ),  
                                  ...portasDisponiveis.map((porta) {  
                                    return DropdownMenuItem<String>(  
                                      value: porta,  
                                      child: Text(porta),  
                                    );  
                                  }),  
                                ],  
                        ),  
                        Icon(  
                          statusConexao[objetoAutomacao] == true  
                              ? Icons.check_circle  
                              : Icons.cancel,  
                          color: statusConexao[objetoAutomacao] == true  
                              ? Colors.green  
                              : Colors.red,  
                        ),  
                      ],  
                    ),  
                  );  
                },  
              ),  
              const SizedBox(height: 16),  
              // Botões de Conexão  
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [  
                  ElevatedButton.icon(  
                    onPressed: iniciarConexao,  
                    icon: const Icon(Icons.play_arrow),  
                    label: const Text('Iniciar Conexão'),  
                    style: ElevatedButton.styleFrom(  
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),  
                      textStyle: const TextStyle(fontSize: 16),  
                    ),  
                  ),  
                  const SizedBox(width: 16),  
                  ElevatedButton.icon(  
                    onPressed: fecharConexao,  
                    icon: const Icon(Icons.stop),  
                    label: const Text('Fechar Conexão'),  
                    style: ElevatedButton.styleFrom(  
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),  
                      textStyle: const TextStyle(fontSize: 16),  
                    ),  
                  ),  
                ],  
              ),  
              const SizedBox(height: 32),  
              // Botão de Atualizar Portas COM
              ElevatedButton.icon(  
                onPressed: _listarPortasDisponiveis,  
                icon: const Icon(Icons.refresh),  
                label: const Text('Atualizar Lista de Portas COM'),  
                style: ElevatedButton.styleFrom(  
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),  
                  textStyle: const TextStyle(fontSize: 16),  
                ),  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}  
