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
  final TextEditingController _acaoController = TextEditingController();
  final TextEditingController _quantidadeSinaisController = TextEditingController();

  // Função para carregar rotinas e suas ações do banco de dados
  void _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    final Map<int, List<Map<String, dynamic>>> acoesPorRotina = {};

    for (var rotina in rotinas) {
      final int idRotina = rotina['ID_ROTINA'];
      final List<Map<String, dynamic>> acoes =
          await DB.instance.getExecucoesRotina(idRotina);
      acoesPorRotina[idRotina] = acoes;
    }

    setState(() {
      _rotinas = rotinas;
      _acoesPorRotina = acoesPorRotina;
    });
  }

  // Função para inserir uma nova rotina
  Future<void> _insertRotina(String nome) async {
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome é obrigatório')),
      );
      return;
    }

    final db = await DB.instance.database;
    await db.insert('rotinas', {'NOME': nome});
    _loadRotinas(); // Atualiza a lista após inserir
  }

  // Função para inserir uma nova ação dentro de uma rotina
  Future<void> _insertAcao(int idRotina, String acao, int qtdSinais) async {
    if (acao.isEmpty || qtdSinais <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ação e quantidade são obrigatórios')),
      );
      return;
    }

    await DB.instance.insertAcao(idRotina, acao, qtdSinais);
    _loadRotinas(); // Atualiza a lista após inserir a ação
  }

  // Função para excluir uma rotina
  Future<void> _deleteRotina(int idRotina) async {
    await DB.instance.deleteRotina(idRotina);
    _loadRotinas(); // Atualiza a lista após excluir
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da nova rotina...',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await _insertRotina(_nomeController.text);
                    _nomeController.clear();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rotinas.length,
              itemBuilder: (context, index) {
                final rotina = _rotinas[index];
                final int idRotina = rotina['ID_ROTINA'];
                final List<Map<String, dynamic>> acoes =
                    _acoesPorRotina[idRotina] ?? [];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(rotina['NOME']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Função de editar rotina (a ser implementada)
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteRotina(idRotina);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _acaoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Ação',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _quantidadeSinaisController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Qtd Sinais',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green),
                                  onPressed: () async {
                                    final String acao = _acaoController.text;
                                    final int qtdSinais = int.tryParse(
                                            _quantidadeSinaisController.text) ??
                                        0;
                                    await _insertAcao(
                                        idRotina, acao, qtdSinais);
                                    _acaoController.clear();
                                    _quantidadeSinaisController.clear();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: acoes.length,
                              itemBuilder: (context, acaoIndex) {
                                final acao = acoes[acaoIndex];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${acao['ACAO']}'),
                                    Text('${acao['QTD_SINAIS']}'),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // Função de editar ação (a ser implementada)
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Função de deletar ação (a ser implementada)
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
