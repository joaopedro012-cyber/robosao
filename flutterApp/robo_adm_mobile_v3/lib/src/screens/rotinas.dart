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

    final db = await DB.instance.database;
    await db.insert('rotinas', {'NOME': nome});
    await _loadRotinas();
  }

  Future<void> _insertAcao(int idRotina, String acao, int qtdSinais) async {
    if (acao.isEmpty || qtdSinais <= 0) {
      _showSnackBar('Ação e quantidade são obrigatórios');
      return;
    }

    // Obter a data e hora atuais em microsegundos
    final dtExecucao = DateTime.now().millisecondsSinceEpoch;

    // Chame a função insertAcao da classe DB com os parâmetros corretos
    await DB.instance.insertAcao(
      idRotina: idRotina,
      acaoHorizontal: acao,
      qtdHorizontal: qtdSinais,
      acaoVertical: '',
      qtdVertical: 0,
      acaoPlataforma: '',
      qtdPlataforma: 0,
      acaoBotao1: '',
      qtdBotao1: 0,
      acaoBotao2: '',
      qtdBotao2: 0,
      acaoBotao3: '',
      qtdBotao3: 0,
      dtExecucao: dtExecucao,
    );

    await _loadRotinas();
  }

  Future<void> _deleteRotina(int idRotina) async {
    await DB.instance.deleteRotina(idRotina);
    await _loadRotinas(); // Atualiza a lista de rotinas após a exclusão
  }

  Future<void> _deleteAcao(int idAcao) async {
    await DB.instance.deleteAcao(idAcao);
    await _loadRotinas(); // Atualiza a lista de rotinas após a exclusão
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
      body: Container(
        color: const Color(0xFFECE6F0), // Cor de fundo
        child: ListView.builder(
          itemCount: _rotinas.length,
          itemBuilder: (context, index) {
            final rotina = _rotinas[index];
            final acoes = _acoesPorRotina[rotina['ID_ROTINA']] ?? [];

            return Card(
              margin: const EdgeInsets.all(8.0), // Margem entre os cards
              child: ExpansionTile(
                title: Text(rotina['NOME']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete), // Ícone de excluir rotina
                  onPressed: () {
                    _deleteRotina(rotina['ID_ROTINA']);
                  },
                ),
                children: [
                  ...acoes.map((acao) {
                    return ListTile(
                      title: Text(acao['ACAO'] ?? 'Ação não definida'), // Verificação de nulidade
                      subtitle: Text('Qtd. de sinais: ${acao['QTD_SINAIS'] ?? 0}'), // Também verifique se QTD_SINAIS é null
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteAcao(acao['ID_EXECUCAO']);
                        },
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _acaoController,
                      decoration: const InputDecoration(labelText: 'Ação'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _quantidadeSinaisController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Qtd. Sinais'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final acao = _acaoController.text;
                        final qtdSinais = int.tryParse(_quantidadeSinaisController.text) ?? 0;
                        _insertAcao(rotina['ID_ROTINA'], acao, qtdSinais);
                      },
                      child: const Text('Adicionar Ação'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nova Rotina'),
                content: TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Rotina'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      final nome = _nomeController.text;
                      _insertRotina(nome);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
