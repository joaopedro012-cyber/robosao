import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/providers/conexao_provider.dart';

class AutomacaoPage extends StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutomacaoView();
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
                      color: const Color(0xFFF3F2F1),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$objetoAutomacao:',
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
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
                              ? FluentIcons.accept
                              : FluentIcons.cancel,
                          color: conexaoProvider.statusConexao[objetoAutomacao] == true
                              ? const Color(0xFF107C10)
                              : const Color(0xFFE81123),
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
                  Button(
                    onPressed: conexaoProvider.iniciarConexao,
                    child: const Text('Iniciar Conexão'),
                  ),
                  const SizedBox(width: 16),
                  Button(
                    onPressed: conexaoProvider.fecharConexao,
                    child: const Text('Fechar Conexão'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Button(
                onPressed: _listarPortasDisponiveis,
                child: const Text('Atualizar Lista de Portas COM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
