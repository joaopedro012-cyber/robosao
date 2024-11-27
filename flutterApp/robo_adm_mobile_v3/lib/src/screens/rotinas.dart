import 'dart:convert';
import 'dart:io'; // Import necessário para manipulação de arquivos
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
  final TextEditingController descricaoController = TextEditingController(); // Novo controlador para a descrição
  final TextEditingController editNomeController = TextEditingController();
  final TextEditingController editDescricaoController = TextEditingController(); // Controlador para editar descrição
  final Map<int, bool> _isExpanded = {};

  Future<void> _loadRotinas() async {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> rotinas = await db.query('rotinas');
    final Map<int, List<Map<String, dynamic>>> acoesPorRotina = {};

    for (var rotina in rotinas) {
      final int idRotina = rotina['id_rotina'] as int? ?? 0;
      final List<Map<String, dynamic>> acoes = await DB.instance.getExecucoesRotina(idRotina);
      acoesPorRotina[idRotina] = acoes;

      _isExpanded.putIfAbsent(idRotina, () => false);
    }

    if (mounted) {
      setState(() {
        _rotinas = rotinas;
        _acoesPorRotina = acoesPorRotina;
      });
    }
  }

  Future<void> _insertRotina(String nome, String descricao) async {
    if (nome.isEmpty || descricao.isEmpty) {
      _showSnackBar('Nome e descrição são obrigatórios');
      return;
    }

    if (_rotinas.any((rotina) => rotina['nome'] == nome)) {
      _showSnackBar('Rotina com este nome já existe');
      return;
    }

    final db = await DB.instance.database;
    await db.insert('rotinas', {'nome': nome, 'descricao': descricao});
    await _loadRotinas();
    setState(() {
      nomeController.clear();
      descricaoController.clear();
    });
  }

  Future<void> _editRotina(int idRotina) async {
    final nome = editNomeController.text;
    final descricao = editDescricaoController.text;

    if (nome.isEmpty || descricao.isEmpty) {
      _showSnackBar('Nome e descrição são obrigatórios');
      return;
    }

    final db = await DB.instance.database;
    await db.update('rotinas', {'nome': nome, 'descricao': descricao}, where: 'id_rotina = ?', whereArgs: [idRotina]);
    await _loadRotinas();
  }

  Future<void> _deleteRotina(int idRotina) async {
    await DB.instance.deleteRotina(idRotina);
    await _loadRotinas();
  }

    Future<void> _exportRotina(int idRotina) async {
    // Encontrar a rotina com base no ID
    final rotina = _rotinas.firstWhere((r) => r['id_rotina'] == idRotina);
    final List<Map<String, dynamic>> acoes = _acoesPorRotina[idRotina] ?? [];
    
    // Criar o mapa que será exportado
    final Map<String, dynamic> rotinaExport = {
      'rotina': rotina,
      'acoes': acoes,
    };

    // Converter para JSON
    final String rotinaJson = jsonEncode(rotinaExport);

    try {
    // Diretório para salvar o arquivo na pasta Downloads
    final directory = Directory('/storage/emulated/0/Download'); // Caminho para downloads no Android
    final filePath = '${directory.path}/rotina_$idRotina.json';

    // Verifica se o diretório existe e cria, se necessário
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Salva o arquivo no caminho
    final file = File(filePath);
    await file.writeAsString(rotinaJson);

    // Mensagem de sucesso
    //ignore: avoid_print
    print('Arquivo salvo com sucesso em: $filePath');
  } catch (e) {
    // Mensagem de erro
    //ignore: avoid_print
    print('Erro ao exportar rotina: $e');
  }
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
        title: const Text(
          'Rotinas',
          style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        centerTitle: true, // Centraliza o título do AppBar
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
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
                        decoration: InputDecoration(
                          hintText: 'Nome da Rotina...',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Cor do texto de dica
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5), // Fundo claro
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 142, 141, 141), // Cor preta para a borda
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 142, 141, 141), // Borda preta ao carregar a página
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF4CAF50), // Cor verde ao focar
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: descricaoController,
                        decoration: InputDecoration(
                          hintText: 'Descrição...',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Cor do texto de dica
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5), // Fundo claro
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 142, 141, 141), // Cor preta para a borda
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 142, 141, 141), // Borda preta ao carregar a página
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF4CAF50), // Cor verde ao focar
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 55, // Altura ajustada para combinar com as text boxes
                      width: 55,  // Largura ajustada para combinar com as text boxes
                      decoration: BoxDecoration(
                        color: Colors.black, // Cor de fundo preta
                        borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas consistentes com as caixas de texto
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white), // Ícone branco para contraste
                        onPressed: () => _insertRotina(nomeController.text, descricaoController.text),
                      ),
                    ),
                  ],
                ),
              ),
              ..._rotinas.map((rotina) {
                final acoes = _acoesPorRotina[rotina['id_rotina']] ?? [];
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
                          rotina['nome'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(rotina['descricao'] ?? 'Sem descrição'), // Exibe a descrição
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
                                  editNomeController.text = rotina['nome'];
                                  editDescricaoController.text = rotina['descricao'] ?? ''; // Carrega a descrição para edição
                                  _showEditDialog(rotina['id_rotina']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 56, 44, 219)),
                                onPressed: () => _deleteRotina(rotina['id_rotina']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download, color: Color.fromARGB(255, 82, 48, 238)),
                                onPressed: () => _exportRotina(rotina['id_rotina']),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isExpanded[rotina['id_rotina']] == true
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: const Color.fromARGB(255, 82, 48, 238),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[rotina['id_rotina']] = !_isExpanded[rotina['id_rotina']]!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isExpanded[rotina['id_rotina']] == true)
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(child: Center(child: Text('VERT.', style: TextStyle(fontWeight: FontWeight.bold)))),

                                  Expanded(child: Center(child: Text('HORIZ.', style: TextStyle(fontWeight: FontWeight.bold)))),

                                  Expanded(child: Center(child: Text('PLAT.', style: TextStyle(fontWeight: FontWeight.bold)))),

                                  Expanded(child: Center(child: Text('BT1', style: TextStyle(fontWeight: FontWeight.bold)))),

                                  Expanded(child: Center(child: Text('BT2', style: TextStyle(fontWeight: FontWeight.bold)))),

                                  Expanded(child: Center(child: Text('BT3', style: TextStyle(fontWeight: FontWeight.bold)))),

                                ],
                              ),
                            ),
                            for (var acao in acoes)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(child: Center(child: Text(acao['acao_vertical']?.toString()?? ''))),
                                    Expanded(child: Center(child: Text(acao['acao_horizontal']?.toString()?? ''))),
                                    Expanded(child: Center(child: Text(acao['acao_plataforma']?.toString()?? ''))),
                                    Expanded(child: Center(child: Text(acao['acao_botao1']?.toString()?? ''))),
                                    Expanded(child: Center(child: Text(acao['acao_botao2']?.toString()?? ''))),
                                    Expanded(child: Center(child: Text(acao['acao_botao3']?.toString()?? ''))),
                                  ],
                                ),
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
  void _showEditDialog(int idRotina) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Rotina"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNomeController,
                decoration: const InputDecoration(
                  hintText: "Novo nome da rotina...",
                ),
              ),
              TextField(
                controller: editDescricaoController,
                decoration: const InputDecoration(
                  hintText: "Nova descrição da rotina...",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Salvar"),
              onPressed: () {
                _editRotina(idRotina);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}