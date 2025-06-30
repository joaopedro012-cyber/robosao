// automacao.dart – Etapa 2.5: exibição das portas COM com Dropdown e tema moderno

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'arduino_comando.dart';

class AutomacaoPage extends StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Arduino Múltiplo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
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
  List<String> logComandos = [];

  final Map<int, String> nomesPortas = {
    1: 'Motor Horizontal',
    2: 'Motor Vertical',
    3: 'Plataforma',
    4: 'Tomadas',
    5: 'Sensores',
  };

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

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _conectarArduino(int numero) {
  String? porta;
  switch (numero) {
    case 1: porta = porta1; break;
    case 2: porta = porta2; break;
    case 3: porta = porta3; break;
    case 4: porta = porta4; break;
    case 5: porta = porta5; break;
  }

  if (porta == null) {
    _mostrarMensagem('Porta $numero não selecionada.');
    return;
  }

  final arduino = ArduinoComando(porta);
  final conectado = arduino.conectar();

  if (!conectado) {
    _mostrarMensagem('Erro ao conectar na porta $porta.');
    return;
  }

  setState(() {
    switch (numero) {
      case 1: arduino1 = arduino; break;
      case 2: arduino2 = arduino; break;
      case 3: arduino3 = arduino; break;
      case 4: arduino4 = arduino; break;
      case 5: arduino5 = arduino; break;
    }
  });

  _mostrarMensagem('Conectado com sucesso: $porta');
}


  Future<void> carregarRotinaJson() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final conteudo = await file.readAsString();
      final jsonCompleto = jsonDecode(conteudo);
      final List<Map<String, dynamic>> comandos = [];

      if (jsonCompleto.containsKey('acoes')) {
        for (var acao in jsonCompleto['acoes']) {
          final Map<String, dynamic> comando = {
            'dt_execucao_unix_microssegundos': acao['dt_execucao_unix_microssegundos'],
          };

          if ((acao['acao_horizontal'] ?? '').toString().isNotEmpty) {
            comando['acao_horizontal'] = acao['acao_horizontal'];
          }
          if ((acao['acao_vertical'] ?? '').toString().isNotEmpty) {
            comando['acao_vertical'] = acao['acao_vertical'];
          }
          if ((acao['acao_plataforma'] ?? '').toString().isNotEmpty) {
            comando['acao_plataforma'] = acao['acao_plataforma'];
          }
          if ((acao['acao_botao1'] ?? '').toString().isNotEmpty) {
            comando['acao_botao1'] = acao['acao_botao1'];
          }
          if ((acao['acao_botao2'] ?? '').toString().isNotEmpty) {
            comando['acao_botao2'] = acao['acao_botao2'];
          }

          comandos.add(comando);
        }

          setState(() {
            comandosGravados = comandos;
          });

          // LOG: imprime todos os comandos carregados
          print('========== ROTINA CARREGADA ==========');
          for (var i = 0; i < comandos.length; i++) {
            print('[$i] → ${comandos[i]}');
          }
          print('======================================');
          if (comandos.isNotEmpty) {
            _mostrarMensagem('Rotina carregada com ${comandos.length} comandos.');
          } else {
            _mostrarMensagem('⚠️ Nenhum comando encontrado na rotina.');
          }
        _mostrarMensagem('Rotina carregada com sucesso!');
      } else {
        _mostrarMensagem('Arquivo inválido: não contém "acoes".');
      }
    } else {
      _mostrarMensagem('Nenhum arquivo selecionado.');
    }
    
  }

  void executarRotina() async {
    if (comandosGravados.isEmpty) {
      _mostrarMensagem('Nenhuma rotina carregada.');
      return;
    }

  comandosGravados.sort((a, b) =>
    (a['dt_execucao_unix_microssegundos'] as int)
        .compareTo(b['dt_execucao_unix_microssegundos'] as int));


  final int baseMillis = comandosGravados.first['dt_execucao_unix_microssegundos'];
  final DateTime baseTime = DateTime.now();

  for (var comando in comandosGravados) {
    final int atualMillis = comando['dt_execucao_unix_microssegundos'];
    final Duration delayReal = Duration(milliseconds: atualMillis - baseMillis);
    final DateTime alvo = baseTime.add(delayReal);
    final Duration restante = alvo.difference(DateTime.now());

      if (restante.inMilliseconds > 0) {
        await Future.delayed(restante);
    }


    final acao = (comando['acao_horizontal'] ??
        comando['acao_vertical'] ??
        comando['acao_plataforma'] ??
        comando['acao_botao1'] ??
        comando['acao_botao2'])
        ?.trim();
        
    if (acao != null) {
      try {
        if (["wr", "wl", "ss", "xr", "xl"].contains(acao) && arduino1 != null) {
          if (arduino1!.porta.isOpen) {
            await arduino1!.enviarComando(acao);
          } else {
            _mostrarMensagem("Erro: Porta 1 não está aberta.");
          }
        } else if (["a", "d"].contains(acao) && arduino2 != null) {
          if (arduino2!.porta.isOpen) {
            await arduino2!.enviarComando(acao);
          } else {
            _mostrarMensagem("Erro: Porta 2 não está aberta.");
          }
        } else if (["b", "c"].contains(acao) && arduino3 != null) {
          if (arduino3!.porta.isOpen) {
            await arduino3!.enviarComando(acao);
          } else {
            _mostrarMensagem("Erro: Porta 3 não está aberta.");
          }
        } else if ((acao == "Ligar Tomada" || acao == "Desligar Tomada") && arduino4 != null) {
          if (arduino4!.porta.isOpen) {
            await arduino4!.enviarComando(acao);
          } else {
            _mostrarMensagem("Erro: Porta 4 não está aberta.");
          }
        }
      } catch (e) {
        _mostrarMensagem("Erro ao enviar comando '$acao': $e");
      }
    }
  }

  _mostrarMensagem('Rotina executada.');

}


  Widget dropdownPorta(int numero, String? selecionada, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selecionada,
      decoration: InputDecoration(
        labelText: nomesPortas[numero],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: portasDisponiveis.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle Arduino')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            dropdownPorta(1, porta1, (val) => setState(() => porta1 = val)),
            ElevatedButton(
              onPressed: () => _conectarArduino(1),
              child: const Text('Conectar Motor Horizontal'),
            ),
            const SizedBox(height: 12),
            dropdownPorta(2, porta2, (val) => setState(() => porta2 = val)),
            ElevatedButton(
              onPressed: () => _conectarArduino(2),
              child: const Text('Conectar Motor Vertical'),
            ),
            const SizedBox(height: 12),
            dropdownPorta(3, porta3, (val) => setState(() => porta3 = val)),
            ElevatedButton(
              onPressed: () => _conectarArduino(3),
              child: const Text('Conectar Plataforma'),
            ),
            const SizedBox(height: 12),
            dropdownPorta(4, porta4, (val) => setState(() => porta4 = val)),
            ElevatedButton(
              onPressed: () => _conectarArduino(4),
              child: const Text('Conectar Tomadas'),
            ),
            const SizedBox(height: 12),
            dropdownPorta(5, porta5, (val) => setState(() => porta5 = val)),
            ElevatedButton(
              onPressed: () => _conectarArduino(5),
              child: const Text('Conectar Sensores'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: carregarRotinaJson,
              icon: const Icon(Icons.upload_file),
              label: const Text('Carregar rotina JSON'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: executarRotina,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Executar rotina'),
            ),
          ],
        ),
      ),
    );
  }
}