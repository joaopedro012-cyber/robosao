import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadRotinas();
  }

  void _loadRotinas() async {
    final data = await DB.instance.getRotinas();
    setState(() {
      _rotinas = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  width: MediaQuery.of(context).size.width * 0.72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFd57171),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
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
                  child: ElevatedButton(
                    onPressed: () {},
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
            const Text(
              "ROTINAS EXISTENTES:",
              style: TextStyle(
                color: Color(0xFFd57171),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                fontSize: 24,
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
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Ativo: ${rotina['ATIVO']}, Editável: ${rotina['EDITAVEL']}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                          child: IconButton(
                            icon: Icon(CupertinoIcons.share),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Exportar rotina'),
                                    actions: [
                                      TextButton(
                                        child: Text('Fechar'),
                                        onPressed: () {
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
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Editar rotina'),
                                    actions: [
                                      TextButton(
                                        child: Text('Fechar'),
                                        onPressed: () {
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
                        IconButton(
                          icon: Icon(CupertinoIcons.xmark_circle),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Excluir rotina'),
                                  actions: [
                                    TextButton(
                                      child: Text('Fechar'),
                                      onPressed: () {
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
