import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';

class ConexaoProvider extends ChangeNotifier {
  final Map<String, String?> configuracoesPortas = {
    'Sensores': null,
    'Motores Horizontal': null,
    'Motores Vertical': null,
    'Plataforma': null,
    'Botões Plataforma': null,
  };

  final Map<String, bool> statusConexao = {
    'Sensores': false,
    'Motores Horizontal': false,
    'Motores Vertical': false,
    'Plataforma': false,
    'Botões Plataforma': false,
  };

  bool conexaoAtiva = false;
  late SerialPort porta;

  void alterarConfiguracaoPorta(String objeto, String? novaPorta) {
    configuracoesPortas[objeto] = novaPorta;
    statusConexao[objeto] = false; // Desconecta automaticamente ao alterar a porta
    notifyListeners();
  }

  void iniciarConexao() {
    try {
      bool algumaConexaoBemSucedida = false;

      configuracoesPortas.forEach((key, value) {
        if (value != null && value.isNotEmpty) {
          try {
            porta = SerialPort(value);
            inicializadorSerialPort(porta);
            statusConexao[key] = true;
            algumaConexaoBemSucedida = true;
          } catch (e) {
            statusConexao[key] = false;
            if (kDebugMode) print("Erro ao conectar na porta $key: $e");
          }
        }
      });

      conexaoAtiva = algumaConexaoBemSucedida;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Erro ao iniciar conexão: $e');
    }
  }

  void fecharConexao() {
    try {
      if (conexaoAtiva) {
        porta.close();
        conexaoAtiva = false;
        statusConexao.updateAll((key, value) => false);
        configuracoesPortas.updateAll((key, value) => null);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao fechar conexão: $e');
    }
  }
}

class AutomacaoPage extends StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConexaoProvider(),
      child: const AutomacaoView(),
    );
  }
}

class AutomacaoView extends StatefulWidget {
  const AutomacaoView({super.key});

  @override
  State<AutomacaoView> createState() => _AutomacaoViewState();
}

class _AutomacaoViewState extends State<AutomacaoView> {
  List<String> portasDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _listarPortasDisponiveis();
  }

  void _listarPortasDisponiveis() {
    final listaPortas = SerialPort.availablePorts;
    setState(() {
      portasDisponiveis = listaPortas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final conexaoProvider = Provider.of<ConexaoProvider>(context);

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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: conexaoProvider.configuracoesPortas.keys.length,
                itemBuilder: (context, index) {
                  String objetoAutomacao =
                      conexaoProvider.configuracoesPortas.keys.elementAt(index);

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
                        Text('$objetoAutomacao:',
                            style: Theme.of(context).textTheme.titleLarge),
                        DropdownButton<String>(
                          value: conexaoProvider.configuracoesPortas[objetoAutomacao],
                          onChanged: (novaPorta) {
                            conexaoProvider.alterarConfiguracaoPorta(
                                objetoAutomacao, novaPorta);
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
                          conexaoProvider.statusConexao[objetoAutomacao] == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              conexaoProvider.statusConexao[objetoAutomacao] ==
                                      true
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: conexaoProvider.iniciarConexao,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar Conexão'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: conexaoProvider.fecharConexao,
                    icon: const Icon(Icons.stop),
                    label: const Text('Fechar Conexão'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _listarPortasDisponiveis,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar Lista de Portas COM'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

void inicializadorSerialPort(SerialPort porta) {
  porta.open(mode: SerialPortMode.readWrite);
}
