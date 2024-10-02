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
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController editNomeController = TextEditingController();
  final TextEditingController vertController = TextEditingController();
  final TextEditingController horizController = TextEditingController();
  final TextEditingController platController = TextEditingController();
  final TextEditingController bt1Controller = TextEditingController();
  final TextEditingController bt2Controller = TextEditingController();
  final TextEditingController bt3Controller = TextEditingController();

  final Map<int, bool> _isExpanded = {}; 

  Future<void> _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    final Map<int, List<Map<String, dynamic>>> acoesPorRotina = {};

    for (var rotina in rotinas) {
      final int idRotina = rotina['ID_ROTINA'] as int? ?? 0;
      final List<Map<String, dynamic>> acoes = await DB.instance.getExecucoesRotina(idRotina);
      acoesPorRotina[idRotina] = acoes;

      if (!_isExpanded.containsKey(idRotina)) {
        _isExpanded[idRotina] = false;
      }
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

  Future<void> _editRotina(int idRotina) async {
    final nome = editNomeController.text;

    if (nome.isEmpty) {
      _showSnackBar('Nome é obrigatório');
      return;
    }

    final db = await DB.instance.database;
    await db.update('rotinas', {'NOME': nome}, where: 'ID_ROTINA = ?', whereArgs: [idRotina]);
    await _loadRotinas();
  }

  Future<void> _insertAcao(int idRotina) async {
    if (vertController.text.isEmpty ||
        horizController.text.isEmpty ||
        platController.text.isEmpty ||
        bt1Controller.text.isEmpty ||
        bt2Controller.text.isEmpty ||
        bt3Controller.text.isEmpty) {
      _showSnackBar('Todos os campos são obrigatórios');
      return;
    }

    final dtExecucao = DateTime.now().millisecondsSinceEpoch;

    await DB.instance.insertAcao(
      idRotina: idRotina,
      acaoHorizontal: horizController.text,
      qtdHorizontal: int.tryParse(horizController.text) ?? 0,
      acaoVertical: vertController.text,
      qtdVertical: int.tryParse(vertController.text) ?? 0,
      acaoPlataforma: platController.text,
      qtdPlataforma: int.tryParse(platController.text) ?? 0,
      acaoBotao1: bt1Controller.text,
      qtdBotao1: int.tryParse(bt1Controller.text) ?? 0,
      acaoBotao2: bt2Controller.text,
      qtdBotao2: int.tryParse(bt2Controller.text) ?? 0,
      acaoBotao3: bt3Controller.text,
      qtdBotao3: int.tryParse(bt3Controller.text) ?? 0,
      dtExecucao: dtExecucao,
    );

    vertController.clear();
    horizController.clear();
    platController.clear();
    bt1Controller.clear();
    bt2Controller.clear();
    bt3Controller.clear();

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
                        controller: nomeController,
                        decoration: const InputDecoration(labelText: 'Nome da Rotina'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[800],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          final nome = nomeController.text;
                          _insertRotina(nome);
                          nomeController.clear();
                        },
                      ),
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
                  color: Colors.white,
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
                              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 109, 6, 128)),
                              onPressed: () {
                                editNomeController.text = rotina['NOME'];
                                _showEditDialog(rotina['ID_ROTINA']);
                              },
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Color.fromARGB(255, 96, 3, 112)),
                                  onPressed: () {
                                    _deleteRotina(rotina['ID_ROTINA']);
                                  },
                                ),
                                const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                _isExpanded[rotina['ID_ROTINA']] == true
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.purple,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isExpanded[rotina['ID_ROTINA']] = !_isExpanded[rotina['ID_ROTINA']]!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_isExpanded[rotina['ID_ROTINA']] == true && acoes.isNotEmpty)
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(acao['acaoVertical'].toString())),
                                      Expanded(child: Text(acao['acaoHorizontal'].toString())),
                                      Expanded(child: Text(acao['acaoPlataforma'].toString())),
                                      Expanded(child: Text(acao['acaoBotao1'].toString())),
                                      Expanded(child: Text(acao['acaoBotao2'].toString())),
                                      Expanded(child: Text(acao['acaoBotao3'].toString())),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.purple),
                                        onPressed: () {
                                          _deleteAcao(acao['ID_ACAO']);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      if (_isExpanded[rotina['ID_ROTINA']] == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: vertController,
                                      decoration: const InputDecoration(labelText: 'VERT.'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: horizController,
                                      decoration: const InputDecoration(labelText: 'HORIZ.'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: platController,
                                      decoration: const InputDecoration(labelText: 'PLAT.'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: bt1Controller,
                                      decoration: const InputDecoration(labelText: 'BT1'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: bt2Controller,
                                      decoration: const InputDecoration(labelText: 'BT2'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: bt3Controller,
                                      decoration: const InputDecoration(labelText: 'BT3'),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.purple),
                                    onPressed: () {
                                      _insertAcao(rotina['ID_ROTINA']);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

  Future<void> _showEditDialog(int idRotina) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Rotina'),
          content: TextField(
            controller: editNomeController,
            decoration: const InputDecoration(labelText: 'Nome da Rotina'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _editRotina(idRotina);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
