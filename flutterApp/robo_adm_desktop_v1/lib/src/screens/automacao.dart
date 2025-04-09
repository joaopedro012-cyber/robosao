import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/providers/conexao_provider.dart';

class AutomacaoPage extends fluent.StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return const AutomacaoView();
  }
}

class AutomacaoView extends fluent.StatefulWidget {
  const AutomacaoView({super.key});

  @override
  fluent.State<AutomacaoView> createState() => _AutomacaoViewState();
}

class _AutomacaoViewState extends fluent.State<AutomacaoView> {
  List<String> portasDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _listarPortasDisponiveis();
  }

  void _listarPortasDisponiveis() {
    setState(() {
      portasDisponiveis = SerialPort.availablePorts;
    });
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final conexaoProvider = Provider.of<ConexaoProvider>(context);

    return material.Scaffold(
      appBar: material.AppBar(
        title: const material.Text('Automação de Robô'),
        backgroundColor: material.Colors.blue,
      ),
      body: material.Padding(
        padding: const material.EdgeInsets.all(16.0),
        child: material.SingleChildScrollView(
          child: material.Column(
            children: [
              material.GridView.builder(
                shrinkWrap: true,
                physics: const material.NeverScrollableScrollPhysics(),
                itemCount: conexaoProvider.configuracoesPortas.keys.length,
                gridDelegate: const material.SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final chave = conexaoProvider.configuracoesPortas.keys.elementAt(index);
                  return material.Card(
                    elevation: 4,
                    child: material.Padding(
                      padding: const material.EdgeInsets.all(8),
                      child: material.Column(
                        crossAxisAlignment: material.CrossAxisAlignment.start,
                        children: [
                          material.Text(
                            '$chave:',
                            style: const material.TextStyle(fontWeight: material.FontWeight.bold),
                          ),
                          material.DropdownButton<String>(
                            isExpanded: true,
                            value: conexaoProvider.configuracoesPortas[chave],
                            hint: const material.Text('Selecione a porta'),
                            items: portasDisponiveis.map((porta) {
                              return material.DropdownMenuItem(
                                value: porta,
                                child: material.Text(porta),
                              );
                            }).toList(),
                            onChanged: (value) {
                              conexaoProvider.alterarConfiguracaoPorta(chave, value);
                            },
                          ),
                          material.Row(
                            children: [
                              material.Text(
                                conexaoProvider.statusConexao[chave] == true
                                    ? 'Conectado'
                                    : 'Desconectado',
                                style: material.TextStyle(
                                  color: conexaoProvider.statusConexao[chave] == true
                                      ? material.Colors.green
                                      : material.Colors.red,
                                  fontWeight: material.FontWeight.w500,
                                ),
                              ),
                              const material.SizedBox(width: 8),
                              material.Icon(
                                conexaoProvider.statusConexao[chave] == true
                                    ? fluent.FluentIcons.accept
                                    : fluent.FluentIcons.cancel,
                                color: conexaoProvider.statusConexao[chave] == true
                                    ? material.Colors.green
                                    : material.Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const material.SizedBox(height: 20),
              material.Row(
                mainAxisAlignment: material.MainAxisAlignment.center,
                children: [
                  fluent.FilledButton(
                    onPressed: conexaoProvider.iniciarConexao,
                    child: const fluent.Text('Iniciar Conexão'),
                  ),
                  const material.SizedBox(width: 16),
                  fluent.FilledButton(
                    onPressed: conexaoProvider.fecharConexao,
                    child: const fluent.Text('Fechar Conexão'),
                  ),
                ],
              ),
              const material.SizedBox(height: 20),
              fluent.FilledButton(
                onPressed: _listarPortasDisponiveis,
                child: const fluent.Text('Atualizar Lista de Portas COM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
