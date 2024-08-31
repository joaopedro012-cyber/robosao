import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: RotinasPage(),
    ),
  );
}

// Função para exportar dados para JSON
Future<void> exportToJson(int idRotina) async {
  final db = await DB.instance.database;

  final List<Map<String, dynamic>> execucoes = await db.query(
    'ADM_EXECUCAO_ROTINAS',
    columns: ['ID_ROTINA', 'QTD_SINAIS', 'ACAO', 'DT_EXECUCAO_UNIX_MICROSSEGUNDOS'],
    where: 'ID_ROTINA = ? AND DT_EXCLUSAO_UNIX_MICROSSEGUNDOS IS NULL',
    whereArgs: [idRotina],
  );

  final jsonData = jsonEncode(execucoes);

  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/execucao_rotina_$idRotina.json';

  final file = File(path);
  await file.writeAsString(jsonData);

  if (kDebugMode) {
    print('Arquivo exportado para $path');
  }
}

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<Map<String, dynamic>> _rotinas = [];
  List<Map<String, dynamic>> _execucoes = [];

  Future<void> atualizaExecucaoRotina(
      int idExecucao, String novaAcao, int novaQtdSinais) async {
    final db = await DB.instance.database;

    Map<String, dynamic> dadosAtualizados = {
      'ACAO': novaAcao,
      'QTD_SINAIS': novaQtdSinais,
    };

    await db.update(
      'ADM_EXECUCAO_ROTINAS',
      dadosAtualizados,
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  Future<void> _loadExecucaoRotinas(int rotinaId) async {
    final data2 = await DB.instance.getExecucaoRotinas(rotinaId);
    setState(() {
      _execucoes = data2;
    });

    if (kDebugMode) {
      print(_execucoes);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRotinas();
    _loadExecucaoRotinas(1);
  }

  void _loadRotinas() async {
    final data = await DB.instance.getRotinas();
    setState(() {
      _rotinas = data;
    });
  }

  Future<void> _insertRotina(String nomeRotina) async {
    await DB.createItem(nomeRotina, "S", "S");
    _loadRotinas();
  }

  Future<void> _deleteRotina(int idRotina) async {
    await DB.deleteItem(idRotina);
    _loadRotinas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? valorTextInput;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 213, 113, 113),
        title: const Text(
          'Rotinas',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const SizedBox(width: 8.0),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 12, 0, 0),
                width: MediaQuery.of(context).size.width * 0.72,
                decoration: BoxDecoration(
                  color: const Color(0xFFd57171),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  onChanged: (texto) {
                    valorTextInput = texto;
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    hintText: 'Nova rotina...',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0, height: 7.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (valorTextInput == null || valorTextInput == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Digite um nome para a rotina'),
                            actions: [
                              TextButton(
                                child: const Text('Voltar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _insertRotina(valorTextInput!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFd57171),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rotinas.length,
              itemBuilder: (context, index) {
                final rotina = _rotinas[index];
                final List<TextEditingController> acaoControllers = [];
                final List<TextEditingController> qtdSinaisControllers = [];

                for (final execucao in _execucoes) {
                  acaoControllers.add(TextEditingController(
                      text: execucao['ACAO']?.toString()));
                  qtdSinaisControllers.add(TextEditingController(
                      text: execucao['QTD_SINAIS']?.toString()));
                }

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rotina['NOME'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(CupertinoIcons.share),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Exportar rotina ${rotina['NOME']}?'),
                                      content: const Text('A exportação vai gerar um arquivo .json'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Voltar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Exportar'),
                                          onPressed: () async {
  int idRotina = rotina['ID_ROTINA'];
  await exportToJson(idRotina);

  // Use um Future.delayed para garantir que o contexto seja usado de forma segura
  if (mounted) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
},



                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        for (var i = 0; i < _execucoes.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: acaoControllers[i],
                                    decoration: const InputDecoration(
                                      labelText: 'Ação',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: TextField(
                                    controller: qtdSinaisControllers[i],
                                    decoration: const InputDecoration(
                                      labelText: 'Qtd Sinais',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () {
                                    final idExecucao = _execucoes[i]['ID_EXECUCAO'];
                                    final novaAcao = acaoControllers[i].text;
                                    final novaQtdSinais = int.tryParse(qtdSinaisControllers[i].text) ?? 0;
                                    atualizaExecucaoRotina(idExecucao, novaAcao, novaQtdSinais);
                                  },
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _deleteRotina(rotina['ID_ROTINA']);
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
