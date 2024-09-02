import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:roboadmv1/screens/home.dart';
import 'package:roboadmv1/database/db.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    const MaterialApp(
      home: RotinasPage(),
    ),
  );
}

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  List<Map<String, dynamic>> _rotinas = [];
  final Map<int, List<Map<String, dynamic>>> _execucoesPorRotina = {};
  // Mapa para armazenar execuções por rotina

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
      _execucoesPorRotina[rotinaId] = data2;  // Atualiza o mapa de execuções
    });

    if (kDebugMode) {
      print(_execucoesPorRotina);
    }
  }

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

    // Carregar execuções para cada rotina
    for (var rotina in _rotinas) {
      _loadExecucaoRotinas(rotina['ID_ROTINA']);
    }
  }

  Future<void> _insertRotina(String nomeRotina) async {
    await DB.createItem(nomeRotina, "S", "S");
    _loadRotinas();
  }

  Future<void> _deleteRotina(int idRotina) async {
    await DB.deleteItem(idRotina);
    _loadRotinas();
  }
  Future<void> _requestStoragePermission() async {
  // Verificar se a permissão já foi concedida
  if (await Permission.storage.request().isGranted) {
    // A permissão já foi concedida, você pode acessar o armazenamento
  } else {
    // Solicitar permissão
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Se a permissão não for concedida, você pode mostrar uma mensagem ao usuário ou fechar a função
      return;
    }
  }
}


  // Função para exportar dados para JSON com escolha de pasta
Future<void> exportToJsonWithPicker(int rotinaId) async {
  // Verifique e solicite permissões de armazenamento
  if (Platform.isAndroid) {
    await _requestStoragePermission();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Abrir o seletor de pasta
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory == null) {
    // Usuário cancelou a seleção
    return;
  }

  // Prepare os dados para exportação
  List<dynamic> jsonReadyData = _execucoesPorRotina[rotinaId] ?? [];

  // Converta os dados da variável jsonReadyData para JSON
  final jsonData = jsonEncode(jsonReadyData);

  // Caminho do arquivo para salvar
  final path = '$selectedDirectory/execucao_rotina_$rotinaId.json';

  final file = File(path);
  await file.writeAsString(jsonData);

  if (kDebugMode) {
    print('Arquivo exportado para $path');
  }
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
                final execucoes = _execucoesPorRotina[rotina['ID_ROTINA']] ?? [];

                final List<TextEditingController> acaoControllers = [];
                final List<TextEditingController> qtdSinaisControllers = [];

                for (final execucao in execucoes) {
                  acaoControllers.add(TextEditingController(
                      text: execucao['ACAO']?.toString()));
                  qtdSinaisControllers.add(TextEditingController(
                      text: execucao['QTD_SINAIS']?.toString()));
                }

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                Navigator.of(context).pop();
                await exportToJsonWithPicker(rotina['ID_ROTINA']);
              },
            ),
          ],
        );
      },
    );
  },
)

                          ],
                        ),
                        const SizedBox(height: 16.0),
                        for (var i = 0; i < execucoes.length; i++)
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
                                      labelText: 'Qtd. Sinais',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () {
                                    final novaAcao = acaoControllers[i].text;
                                    final novaQtdSinais = int.tryParse(
                                            qtdSinaisControllers[i].text) ??
                                        0;
                                    final idExecucao =
                                        execucoes[i]['ID_EXECUCAO'];
                                    atualizaExecucaoRotina(idExecucao, novaAcao,
                                        novaQtdSinais);
                                  },
                                ),
                              ],
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteRotina(rotina['ID_ROTINA']);
                              },
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
