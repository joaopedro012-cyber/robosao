import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
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
  String? caminhoArquivoRotina;
  dynamic rotinaJson;

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

  Future<void> _mostrarDialogo(String mensagem) async {
  await fluent.showDialog(
    context: context,
    builder: (_) => fluent.ContentDialog(
      title: const fluent.Text('Informação'),
      content: fluent.Text(mensagem),
      actions: [
        fluent.Button(
          child: const fluent.Text('OK'),
          onPressed: () => material.Navigator.pop(context),
        ),
      ],
    ),
  );
}


  Future<void> _selecionarRotina() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      setState(() {
        caminhoArquivoRotina = result.files.single.name;
        rotinaJson = json.decode(contents);
      });

      if (!mounted) return;
      _mostrarDialogo('Rotina carregada com sucesso!');
    }
  }

  Future<void> _iniciarConexaoEExecutarRotina(ConexaoProvider conexaoProvider) async {
    await conexaoProvider.iniciarConexao();

    final todasConectadas = conexaoProvider.statusConexao.values.every((conectado) => conectado == true);

    if (todasConectadas && rotinaJson != null) {
      await conexaoProvider.executarRotina(rotinaJson);

      if (!mounted) return;
      _mostrarDialogo('Rotina executada com sucesso!');
    } else if (rotinaJson == null) {
      if (!mounted) return;
      _mostrarDialogo('Selecione uma rotina antes de iniciar.');
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final conexaoProvider = Provider.of<ConexaoProvider>(context);

    return material.Scaffold(
      appBar: material.AppBar(
        title: const material.Text('Automação de Robô'),
        backgroundColor: material.Colors.blue,
      ),
      body: material.SafeArea(
        child: material.Padding(
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

                fluent.FilledButton(
                  onPressed: _selecionarRotina,
                  child: fluent.Text(caminhoArquivoRotina != null
                      ? 'Rotina Selecionada: $caminhoArquivoRotina'
                      : 'Selecionar Rotina (JSON)'),
                ),
                const material.SizedBox(height: 16),

                material.Row(
                  mainAxisAlignment: material.MainAxisAlignment.center,
                  children: [
                    fluent.FilledButton(
                      onPressed: () => _iniciarConexaoEExecutarRotina(conexaoProvider),
                      child: const fluent.Text('Iniciar Conexão e Executar Rotina'),
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
      ),
    );
  }
}
