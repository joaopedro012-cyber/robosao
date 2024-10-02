import 'package:flutter/material.dart';
import 'package:robo_adm_mobile_v2/src/database/db.dart';

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<Map<String, dynamic>> _rotinas = [];
  Map<int, List<Map<String, dynamic>>> _acoesPorRotina = {};

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _vertController = TextEditingController();
  final TextEditingController _horizController = TextEditingController();
  final TextEditingController _platController = TextEditingController();
  final TextEditingController _bt1Controller = TextEditingController();
  final TextEditingController _bt2Controller = TextEditingController();
  final TextEditingController _bt3Controller = TextEditingController();

  Future<void> _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    final Map<int, List<Map<String, dynamic>>> acoesPorRotina = {};

    for (var rotina in rotinas) {
      final int idRotina = rotina['ID_ROTINA'] as int? ?? 0;
      final List<Map<String, dynamic>> acoes = await DB.instance.getExecucoesRotina(idRotina);
      acoesPorRotina[idRotina] = acoes;
    }

    if (mounted) {
      setState(() {
        _rotinas = rotinas;
        _acoesPorRotina = acoesPorRotina;
      });
    }
  }

  Future<void> _insertRotina(String nome) async {
    if (nome.isEmpty) {
      _showSnackBar('Nome é obrigatório');
      return;
    }

    if (_rotinas.any((rotina) => rotina['NOME'] == nome)) {
      _showSnackBar('Rotina com este nome já existe');
      return;
    }

    final db = await DB.instance.database;
    await db.insert('rotinas', {'NOME': nome});
    await _loadRotinas();
  }

  Future<void> _insertAcao(int idRotina) async {
    if (_vertController.text.isEmpty ||
        _horizController.text.isEmpty ||
        _platController.text.isEmpty ||
        _bt1Controller.text.isEmpty ||
        _bt2Controller.text.isEmpty ||
        _bt3Controller.text.isEmpty) {
      _showSnackBar('Todos os campos são obrigatórios');
      return;
    }

    final dtExecucao = DateTime.now().millisecondsSinceEpoch;

    await DB.instance.insertAcao(
      idRotina: idRotina,
      acaoHorizontal: _horizController.text,
      qtdHorizontal: int.tryParse(_horizController.text) ?? 0,
      acaoVertical: _vertController.text,
      qtdVertical: int.tryParse(_vertController.text) ?? 0,
      acaoPlataforma: _platController.text,
      qtdPlataforma: int.tryParse(_platController.text) ?? 0,
      acaoBotao1: _bt1Controller.text,
      qtdBotao1: int.tryParse(_bt1Controller.text) ?? 0,
      acaoBotao2: _bt2Controller.text,
      qtdBotao2: int.tryParse(_bt2Controller.text) ?? 0,
      acaoBotao3: _bt3Controller.text,
      qtdBotao3: int.tryParse(_bt3Controller.text) ?? 0,
      dtExecucao: dtExecucao,
    );

    _vertController.clear();
    _horizController.clear();
    _platController.clear();
    _bt1Controller.clear();
    _bt2Controller.clear();
    _bt3Controller.clear();

    await _loadRotinas();
  }

  Future<void> _deleteRotina(int idRotina) async {
    await DB.instance.deleteRotina(idRotina);
    await _loadRotinas();
  }

  Future<void> _deleteAcao(int idAcao) async {
    await DB.instance.deleteAcao(idAcao);
    await _loadRotinas();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRotinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotinas'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFECE6F0),
          child: Column(
            children: [
              // Campo para adicionar novas rotinas
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nomeController,
                        decoration: const InputDecoration(labelText: 'Nome da Rotina'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final nome = _nomeController.text;
                        _insertRotina(nome);
                        _nomeController.clear();
                      },
                    ),
                  ],
                ),
              ),
              // Exibindo as rotinas
              ..._rotinas.map((rotina) {
                final acoes = _acoesPorRotina[rotina['ID_ROTINA']] ?? [];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          rotina['NOME'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Adicione a lógica de edição aqui
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteRotina(rotina['ID_ROTINA']);
                              },
                            ),
                          ],
                        ),
                      ),
                      if (acoes.isNotEmpty)
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text("VERT.", style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(child: Text("HORIZ.", style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(child: Text("PLAT.", style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(child: Text("BT1", style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(child: Text("BT2", style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(child: Text("BT3", style: TextStyle(fontWeight: FontWeight.bold))),
                                  SizedBox(width: 60), // Espaço para os botões
                                ],
                              ),
                            ),
                            Column(
                              children: acoes.map((acao) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(acao['qtdVertical'].toString())),
                                      Expanded(child: Text(acao['qtdHorizontal'].toString())),
                                      Expanded(child: Text(acao['qtdPlataforma'].toString())),
                                      Expanded(child: Text(acao['qtdBotao1'].toString())),
                                      Expanded(child: Text(acao['qtdBotao2'].toString())),
                                      Expanded(child: Text(acao['qtdBotao3'].toString())),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              // Adicione a lógica de edição aqui
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteAcao(acao['ID_EXECUCAO']);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      _buildNovaAcaoInput(rotina['ID_ROTINA']),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNovaAcaoInput(int idRotina) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _vertController,
                  decoration: const InputDecoration(labelText: 'VERT.'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _horizController,
                  decoration: const InputDecoration(labelText: 'HORIZ.'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _platController,
                  decoration: const InputDecoration(labelText: 'PLAT.'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bt1Controller,
                  decoration: const InputDecoration(labelText: 'BT1'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bt2Controller,
                  decoration: const InputDecoration(labelText: 'BT2'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bt3Controller,
                  decoration: const InputDecoration(labelText: 'BT3'),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _insertAcao(idRotina);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
