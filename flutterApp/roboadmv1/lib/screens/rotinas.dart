import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';

void main() {
  runApp(const RotinasPage());
}

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<Map<String, dynamic>> _rotinas = [];
  List<Map<String, dynamic>> _execucoes = [];

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
                                        fontWeight: FontWeight.w500),
                                    content: const Text(
                                        'A exportação vai gerar um arquivo .json'),
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
                                          textStyle: WidgetStateProperty.all<
                                              TextStyle>(
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
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        onPressed: () {
                                          int idRotina = rotina['ROTINA'];
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
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              int idRotina2 = 1;
                              _loadExecucaoRotinas(idRotina2);
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
                                        titleTextStyle: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                        content: Expanded(
                                          child: ListView.builder(
                                            itemCount: _execucoes.length,
                                            itemBuilder: (context, index) {
                                              final execucao = _execucoes[index];
                                              return ListTile(
                                                title: Text(
                                                  execucao['ACAO'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                subtitle: Text(
                                                  'ID: ${execucao['QTD_SINAIS']}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
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
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.black),
                                              textStyle: WidgetStateProperty
                                                  .all<TextStyle>(
                                                const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Atualizar'),
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(
                                                Colors.blue,
                                              ),
                                              textStyle: WidgetStateProperty
                                                  .all<TextStyle>(
                                                const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            onPressed: () {
                                              int idRotina = rotina['ROTINA'];
                                              _deleteRotina(idRotina);
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
