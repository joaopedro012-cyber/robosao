import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const RotinasPage());
}

// Função para exportar dados para JSON
Future<void> exportToJson(int idRotina) async {
  // Obtenha a instância do banco de dados
  final db = await DB.instance.database;

  // Recupere os dados da tabela ADM_EXECUCAO_ROTINAS
  final List<Map<String, dynamic>> execucoes = await db.query(
    'ADM_EXECUCAO_ROTINAS',
    columns: ['ID_ROTINA', 'QTD_SINAIS', 'ACAO', 'DT_EXECUCAO_UNIX_MICROSSEGUNDOS'],
    where: 'ID_ROTINA = ? AND DT_EXCLUSAO_UNIX_MICROSSEGUNDOS IS NULL',
    whereArgs: [idRotina],
  );

  // Converta os dados para JSON
  final jsonData = jsonEncode(execucoes);

  // Encontre o diretório para salvar o arquivo
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/execucao_rotina_${idRotina}.json';

  // Crie e escreva o arquivo JSON
  final file = File(path);
  await file.writeAsString(jsonData);

  print('Arquivo exportado para $path');
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

    // Define os dados que serão atualizados
    Map<String, dynamic> dadosAtualizados = {
      'ACAO': novaAcao,
      'QTD_SINAIS': novaQtdSinais,
    };

    // Executa a atualização no banco de dados
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

    // Debug: Verificar o conteúdo de _execucoes
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

  Future<void> _insertRotina(nomeRotina) async {
    await DB.createItem(nomeRotina, "S", "S");
    _loadRotinas();
  }

  Future<void> _deleteRotina(idRotina) async {
    await DB.deleteItem(idRotina);
    _loadRotinas();
  }

  @override
  Widget build(BuildContext context) {
    String? valorTextInput;
    //String? valorDelete;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 213, 113, 113),
          title: const Text(
            'Rotinas',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
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
                const SizedBox(
                  width: 8.0,
                ),
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
                const SizedBox(
                  width: 8.0,
                  height: 7.0,
                ),
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
                                  child: const Text('Fechar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _insertRotina(valorTextInput);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd57171),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(55, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Icon(CupertinoIcons.plus),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 16.0,
              height: 7.0,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
              child: Text(
                "ROTINAS EXISTENTES:",
                style: TextStyle(
                  color: Color(0xFFd57171),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(color: Color(0xFFd57171)),
            Expanded(
              child: ListView.builder(
                itemCount: _rotinas.length,
                itemBuilder: (context, index) {
                  final rotina = _rotinas[index];
                  return ListTile(
                    title: Text(
                      rotina['NOME'],
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'ID: ${rotina['ID_ROTINA']}',
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: IconButton(
                            icon: const Icon(CupertinoIcons.share),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Exportar rotina ${rotina['NOME']}?'),
                                    titleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    content: const Text(
                                      'A exportação vai gerar um arquivo .json',
                                    ),
                                    contentTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Voltar'),
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.black),
                                          textStyle: WidgetStateProperty.all<
                                              TextStyle>(
                                            const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Exportar'),
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.purple),
                                          textStyle: WidgetStateProperty.all<
                                              TextStyle>(
                                            const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          int idRotina = rotina['ID_ROTINA'];
                                          await exportToJson(idRotina);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFd57171),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(55, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              int idRotina = rotina['ID_ROTINA'];
                              await _loadExecucaoRotinas(idRotina);

                              // Lista de controladores para campos editáveis
                              List<TextEditingController> acaoControllers = [];
                              List<TextEditingController> qtdSinaisControllers =
                                  [];

                              // Inicializa controladores com os dados atuais
                              for (var execucao in _execucoes) {
                                acaoControllers.add(TextEditingController(
                                    text: execucao['ACAO']));
                                qtdSinaisControllers.add(TextEditingController(
                                    text: execucao['QTD_SINAIS'].toString()));
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.99,
                                      child: AlertDialog(
                                        title: Text('Edição ${rotina['NOME']}'),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return ListView.builder(
                                              itemCount: _execucoes.length,
                                              itemBuilder: (context, index) {
                                                final execucao =
                                                    _execucoes[index];
                                                TextEditingController
                                                    acaoController =
                                                    TextEditingController(
                                                        text: execucao['ACAO']);
                                                TextEditingController
                                                    qtdSinaisController =
                                                    TextEditingController(
                                                        text: execucao[
                                                                'QTD_SINAIS']
                                                            .toString());

                                                return ListTile(
                                                  title: TextField(
                                                    controller: acaoController,
                                                    decoration: InputDecoration(
                                                        labelText: 'ACAO'),
                                                  ),
                                                  subtitle: TextField(
                                                    controller:
                                                        qtdSinaisController,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'QTD_SINAIS'),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  trailing: ElevatedButton(
                                                    onPressed: () {
                                                      int idExecucao = execucao[
                                                          'ID_EXECUCAO'];
                                                      String novaAcao =
                                                          acaoController.text;
                                                      int novaQtdSinais =
                                                          int.parse(
                                                              qtdSinaisController
                                                                  .text);

                                                      // Use uma função assíncrona para lidar com a atualização
                                                      atualizaExecucaoRotina(
                                                              idExecucao,
                                                              novaAcao,
                                                              novaQtdSinais)
                                                          .then((_) {
                                                        // Crie uma cópia mutável de execucao
                                                        final updatedExecucao =
                                                            Map<String,
                                                                    dynamic>.from(
                                                                execucao);
                                                        updatedExecucao[
                                                            'ACAO'] = novaAcao;
                                                        updatedExecucao[
                                                                'QTD_SINAIS'] =
                                                            novaQtdSinais;

                                                        setState(() {
                                                          // Atualize a lista _execucoes com a cópia atualizada
                                                          _execucoes[index] =
                                                              updatedExecucao;
                                                        });
                                                      }).catchError((error) {
                                                        // Trate qualquer erro que possa ocorrer
                                                        print(
                                                            'Erro ao atualizar execução: $error');
                                                      });
                                                    },
                                                    child: Text('Salvar'),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Voltar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFd57171),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(55, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.xmark_circle),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text('Excluir rotina ${rotina['NOME']}?'),
                                  titleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                  content: const Text(
                                      'A exclusão da rotina será permanente.'),
                                  contentTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                  actions: [
                                    TextButton(
                                      child: const Text('Voltar'),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.black),
                                        textStyle:
                                            WidgetStateProperty.all<TextStyle>(
                                          const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Excluir'),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.red),
                                        textStyle:
                                            WidgetStateProperty.all<TextStyle>(
                                          const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      onPressed: () {
                                        int idRotina = rotina['ID_ROTINA'];
                                        _deleteRotina(idRotina);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFd57171),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(55, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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
      ),
    );
  }
}
