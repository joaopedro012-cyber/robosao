// Importações necessárias
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'arduino_comando.dart';
import 'package:robo_adm_desktop_v1/main.dart';

void main() {
  runApp(const MyApp());
}

class AutomacaoPage extends StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Arduino Múltiplo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> portasDisponiveis = [];
  String? porta1, porta2, porta3, porta4, porta5;
  ArduinoComando? arduino1, arduino2, arduino3, arduino4, arduino5;
  List<Map<String, dynamic>> comandosGravados = [];

  @override
  void initState() {
    super.initState();
    _carregarPortas();
  }

  void _carregarPortas() {
    try {
      setState(() {
        portasDisponiveis = SerialPort.availablePorts;
      });
    } catch (e) {
      _mostrarMensagem('Erro ao carregar portas: $e');
    }
  }

  void _conectar(int numero) {
    String? porta;
    if (numero == 1) porta = porta1;
    if (numero == 2) porta = porta2;
    if (numero == 3) porta = porta3;
    if (numero == 4) porta = porta4;
    if (numero == 5) porta = porta5;

    if (porta != null) {
      final arduino = ArduinoComando(porta);
      if (arduino.conectar()) {
        setState(() {
          switch (numero) {
            case 1:
              arduino1 = arduino;
              break;
            case 2:
              arduino2 = arduino;
              break;
            case 3:
              arduino3 = arduino;
              break;
            case 4:
              arduino4 = arduino;
              break;
            case 5:
              arduino5 = arduino;
              break;
          }
        });
        _mostrarMensagem('Arduino $numero conectado com sucesso!');
      } else {
        _mostrarMensagem('Erro ao conectar Arduino $numero!');
      }
    }
  }

  Future<void> _enviarParaTodos(String comando, {bool gravar = false}) async {
    List<ArduinoComando?> arduinos = [arduino1, arduino2, arduino3, arduino4, arduino5];

    if (arduinos.every((a) => a == null)) {
      _mostrarMensagem('Nenhum Arduino conectado!');
      return;
    }

    for (var arduino in arduinos) {
      if (arduino != null) {
        arduino.enviarComando(comando);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (gravar) {
      final int microssegundos = DateTime.now().microsecondsSinceEpoch;
      setState(() {
        comandosGravados.add({'comando': comando, 'dt_execucao_unix_microssegundos': microssegundos});
      });
    }

    _mostrarMensagem('Comando "$comando" enviado.');
  }

  void _mostrarMensagem(String mensagem) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
    }
  }

  void _executarRotina() async {
    if (comandosGravados.isEmpty) {
      _mostrarMensagem('Nenhuma rotina gravada!');
      return;
    }

    _mostrarMensagem('Executando rotina...');

    for (int i = 0; i < comandosGravados.length; i++) {
      final comandoAtual = comandosGravados[i];
      final comando = comandoAtual['comando'];
      final tempoAtual = comandoAtual['dt_execucao_unix_microssegundos'] as int;

      await _enviarParaTodos(comando, gravar: false);

      if (i + 1 < comandosGravados.length) {
        final proximoTempo = comandosGravados[i + 1]['dt_execucao_unix_microssegundos'] as int;
        final diferencaMicros = proximoTempo - tempoAtual;
        final duracao = Duration(microseconds: diferencaMicros);
        if (duracao.inMilliseconds > 0) {
          await Future.delayed(duracao);
        }
      }
    }

    _mostrarMensagem('Rotina executada com sucesso!');
  }

 Future<void> _executarRotinaViaJson() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result == null || result.files.single.path == null) {
    _mostrarMensagem('Nenhum arquivo selecionado.');
    return;
  }

  try {
    final file = File(result.files.single.path!);
    final content = await file.readAsString();

    final Map<String, dynamic> dados = json.decode(content);
    final List<dynamic> acoes = dados['acoes'] ?? [];

    if (acoes.isEmpty) {
      _mostrarMensagem('O JSON está vazio.');
      return;
    }

    _mostrarMensagem('Executando comandos do JSON...');

    // Tempo base de execução (primeira ação)
    final int tempoInicial = acoes.first['dt_execucao_unix_microssegundos'] ?? 0;
    final int inicioReal = DateTime.now().microsecondsSinceEpoch;

    for (var acao in acoes) {
      final int tempoAcao = acao['dt_execucao_unix_microssegundos'] ?? 0;
      final int tempoEsperado = inicioReal + (tempoAcao - tempoInicial);
      final int agora = DateTime.now().microsecondsSinceEpoch;
      final int espera = tempoEsperado - agora;

      if (espera > 0) {
        await Future.delayed(Duration(microseconds: espera));
      }

      if (acao['acao_horizontal'] != null && acao['acao_horizontal'].toString().isNotEmpty) {
        await arduino1?.enviarComando(acao['acao_horizontal'].toString());
      }
      if (acao['acao_vertical'] != null && acao['acao_vertical'].toString().isNotEmpty) {
        await arduino2?.enviarComando(acao['acao_vertical'].toString());
      }
      if (acao['acao_plataforma'] != null && acao['acao_plataforma'].toString().isNotEmpty) {
        await arduino3?.enviarComando(acao['acao_plataforma'].toString());
      }
      if (acao['botao1'] != null && acao['botao1'].toString().isNotEmpty) {
        await arduino4?.enviarComando(acao['botao1'].toString());
      }
      if (acao['botao2'] != null && acao['botao2'].toString().isNotEmpty) {
        await arduino5?.enviarComando(acao['botao2'].toString());
      }
    }

    _mostrarMensagem('Execução via JSON concluída!');
  } catch (e) {
    _mostrarMensagem('Erro ao executar JSON: $e');
  }
}


  void _excluirRotina() {
    setState(() => comandosGravados.clear());
    _mostrarMensagem('Rotina excluída com sucesso!');
  }

  @override
  void dispose() {
    arduino1?.fecharPorta();
    arduino2?.fecharPorta();
    arduino3?.fecharPorta();
    arduino4?.fecharPorta();
    arduino5?.fecharPorta();
    super.dispose();
  }

  Widget _seletorPorta(int numero, String? portaSelecionada, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Arduino $numero', style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: portaSelecionada,
          hint: const Text('Selecione a porta COM'),
          items: portasDisponiveis.map((String porta) {
            return DropdownMenuItem(value: porta, child: Text(porta));
          }).toList(),
          onChanged: onChanged,
        ),
        ElevatedButton.icon(
          onPressed: () => _conectar(numero),
          icon: const Icon(Icons.usb),
          label: const Text('Conectar'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _botoesComando() {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      ElevatedButton(
        onPressed: () => _enviarParaTodos('wl', gravar: true),
        child: const Text('Frente Lenta (wl)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('wr', gravar: true),
        child: const Text('Frente Rápida (wr)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('xl', gravar: true),
        child: const Text('Trás Lenta (xl)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('xr', gravar: true),
        child: const Text('Trás Rápida (xr)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('ss', gravar: true),
        child: const Text('Parar (ss)'),
      ),
      // Botões adicionais (se ainda quiser manter)
      ElevatedButton(
        onPressed: () => _enviarParaTodos('a', gravar: true),
        child: const Text('Esquerda (a)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('d', gravar: true),
        child: const Text('Direita (d)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('c', gravar: true),
        child: const Text('Cima (c)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('b', gravar: true),
        child: const Text('Baixo (b)'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('ligar tomada 1', gravar: true),
        child: const Text('Ligar Tomada 1'),
      ),
      ElevatedButton(
        onPressed: () => _enviarParaTodos('desligar tomada 1', gravar: true),
        child: const Text('Desligar Tomada 1'),
      ),
    ],
  );
}


  Widget _listaComandosGravados() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comandosGravados.length,
      itemBuilder: (context, index) {
        final comando = comandosGravados[index];
        return ListTile(
          title: Text(comando['comando']),
          subtitle: Text('Timestamp micros: ${comando['dt_execucao_unix_microssegundos']}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Arduino Múltiplo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _seletorPorta(1, porta1, (val) => setState(() => porta1 = val)),
            _seletorPorta(2, porta2, (val) => setState(() => porta2 = val)),
            _seletorPorta(3, porta3, (val) => setState(() => porta3 = val)),
            _seletorPorta(4, porta4, (val) => setState(() => porta4 = val)),
            _seletorPorta(5, porta5, (val) => setState(() => porta5 = val)),
            const SizedBox(height: 20),
            _botoesComando(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: _executarRotina, icon: const Icon(Icons.play_arrow), label: const Text('Executar Rotina')),
                ElevatedButton.icon(onPressed: _executarRotinaViaJson, icon: const Icon(Icons.file_open), label: const Text('Executar via JSON')),
                ElevatedButton.icon(onPressed: _excluirRotina, icon: const Icon(Icons.delete), label: const Text('Excluir Rotina')),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Comandos Gravados:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: _listaComandosGravados()),
          ],
        ),
      ),
    );
  }
}
