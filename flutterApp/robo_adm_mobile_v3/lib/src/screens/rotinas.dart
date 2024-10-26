import 'package:flutter/material.dart';  
import 'package:robo_adm_mobile_v2/src/database/db.dart';

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<Map<String, dynamic>> _rotinas = [];
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController editNomeController = TextEditingController();
  final Map<int, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    _loadRotinas();
  }

  // Método para carregar rotinas e suas ações
  Future<void> _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    for (var rotina in rotinas) {
      _isExpanded.putIfAbsent(rotina['ID_ROTINA'], () => false);
    }

    if (mounted) {
      setState(() {
        _rotinas = rotinas;
      });
    }
  }

  Future<void> registerAction(int idRotina, Map<String, dynamic> acao) async {
    final db = await DB.instance.database;
    await db.insert('acoes', {...acao, 'ID_ROTINA': idRotina});
    await _loadRotinas();
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

    setState(() {
      nomeController.clear();
    });
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

  Future<void> _deleteRotina(int idRotina) async {
    await DB.instance.deleteRotina(idRotina);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotinas'),
        backgroundColor: const Color.fromARGB(255, 69, 94, 235),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color(0xFFECE6F0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          hintText: 'Nome da nova rotina...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 88, 69, 252),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          final nome = nomeController.text;
                          _insertRotina(nome);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ..._rotinas.map((rotina) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 237, 239, 247),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          rotina['NOME'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_note, color: Color.fromARGB(255, 53, 36, 204)),
                                onPressed: () {
                                  editNomeController.text = rotina['NOME'];
                                  _showEditDialog(rotina['ID_ROTINA']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 56, 44, 219)),
                                onPressed: () {
                                  _deleteRotina(rotina['ID_ROTINA']);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _isExpanded[rotina['ID_ROTINA']] == true
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: const Color.fromARGB(255, 82, 48, 238),
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
                      ),
                      if (_isExpanded[rotina['ID_ROTINA']] == true)
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text('VERT.', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('HORIZ.', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('PLAT.', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('BT1', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('BT2', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('BT3', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<List<Map<String, dynamic>>>( 
                              stream: DB.instance.streamAcoesPorRotina(rotina['ID_ROTINA']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text('Nenhuma ação registrada.');
                                }
                                final acoes = snapshot.data!;
                                return Column(
                                  children: [
                                    for (var acao in acoes)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(child: Center(child: Text(acao['ACAO_VERTICAL'].toString()))),
                                            Expanded(child: Center(child: Text(acao['ACAO_HORIZONTAL'].toString()))),
                                            Expanded(child: Center(child: Text(acao['PLATAFORMA'].toString()))),
                                            Expanded(child: Center(child: Text(acao['BT1'].toString()))),
                                            Expanded(child: Center(child: Text(acao['BT2'].toString()))),
                                            Expanded(child: Center(child: Text(acao['BT3'].toString()))),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final acao = {
                                  'ACAO_VERTICAL': 32,
                                  'ACAO_HORIZONTAL': 32,
                                  'PLATAFORMA': 50,
                                  'BT1': 4,
                                  'BT2': 4,
                                  'BT3': 4,
                                };
                                await registerAction(rotina['ID_ROTINA'], acao);
                                _showSnackBar('Ação registrada com sucesso!'); // Feedback ao usuário
                              },
                              child: const Text('Registrar Ação'),
                            ),
                          ],
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

  Future<void> _showEditDialog(int idRotina) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Rotina'),
          content: TextField(
            controller: editNomeController,
            decoration: const InputDecoration(hintText: 'Novo nome...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editRotina(idRotina);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
