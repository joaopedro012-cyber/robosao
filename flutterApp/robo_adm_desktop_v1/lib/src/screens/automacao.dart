// Importações necessárias para o funcionamento do app
import 'package:flutter/material.dart'; // Interface gráfica
import 'package:flutter_libserialport/flutter_libserialport.dart'; // Comunicação serial
import 'package:file_picker/file_picker.dart'; // Seleção de arquivos
import 'dart:convert'; // Leitura e conversão de JSON
import 'dart:io'; // Manipulação de arquivos
import 'dart:async'; // Delays
import 'arduino_comando.dart'; // Classe que gerencia a comunicação com Arduino
import 'package:robo_adm_desktop_v1/main.dart'; // Main principal do app (caso use navegação entre telas)

// Ponto de entrada do app
void main() {
  runApp(const MyApp()); // Roda o app principal
}

// Tela específica da automação com múltiplos Arduinos
class AutomacaoPage extends StatelessWidget {
  const AutomacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Arduino Múltiplo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), // Carrega a HomePage como tela principal
    );
  }
}

// Tela com estado (interface e lógica)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Classe de estado que gerencia o funcionamento da HomePage
class _HomePageState extends State<HomePage> {
  // Variáveis para armazenar as portas e objetos Arduino conectados
  List<String> portasDisponiveis = [];
  String? porta1, porta2, porta3;
  ArduinoComando? arduino1, arduino2, arduino3;
  List<Map<String, dynamic>> comandosGravados = []; // Armazena os comandos para rotina

  @override
  void initState() {
    super.initState();
    _carregarPortas(); // Carrega portas disponíveis assim que a tela abre
  }

  // Busca todas as portas seriais disponíveis no sistema
  void _carregarPortas() {
    setState(() {
      portasDisponiveis = SerialPort.availablePorts;
    });
  }

  // Conecta a uma das portas selecionadas
  void _conectar(int numero) {
    String? porta;
    if (numero == 1) porta = porta1;
    if (numero == 2) porta = porta2;
    if (numero == 3) porta = porta3;

    if (porta != null) {
      final arduino = ArduinoComando(porta); // Cria instância do Arduino
      if (arduino.conectar()) {
        // Se conectou com sucesso, salva a instância correspondente
        setState(() {
          if (numero == 1) arduino1 = arduino;
          if (numero == 2) arduino2 = arduino;
          if (numero == 3) arduino3 = arduino;
        });
        _mostrarMensagem('Arduino $numero conectado com sucesso!');
      } else {
        _mostrarMensagem('Erro ao conectar Arduino $numero!');
      }
    }
  }

  // Envia um comando para todos os Arduinos conectados
  void _enviarParaTodos(String comando, {bool gravar = false}) async {
    if (arduino1 == null && arduino2 == null && arduino3 == null) {
      _mostrarMensagem('Nenhum Arduino conectado!');
      return;
    }

    // Envia comando com delay entre cada envio
    if (arduino1 != null) {
      arduino1!.enviarComando(comando);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (arduino2 != null) {
      arduino2!.enviarComando(comando);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (arduino3 != null) {
      arduino3!.enviarComando(comando);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Se a flag gravar estiver ativa, adiciona aos comandos gravados
    if (gravar) {
      setState(() {
        comandosGravados.add({'comando': comando, 'tempo': 500});
      });
    }

    _mostrarMensagem('Comando "$comando" enviado para todos os Arduinos conectados.');
  }

  // Exibe uma mensagem na tela (Snackbar)
  void _mostrarMensagem(String mensagem) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }

  // Executa os comandos salvos na lista `comandosGravados`
  void _executarRotina() async {
    if (comandosGravados.isEmpty) {
      _mostrarMensagem('Nenhuma rotina gravada!');
      return;
    }

    _mostrarMensagem('Executando rotina...');

    // Envia comando por comando com seus respectivos tempos
    for (var item in comandosGravados) {
      final String comando = item['comando'];
      final int tempo = item['tempo'];

      _enviarParaTodos(comando, gravar: false); // Não grava novamente
      await Future.delayed(Duration(milliseconds: tempo));
    }

    _mostrarMensagem('Rotina executada com sucesso!');
  }

  // Executa rotina baseada em um arquivo JSON
  void _executarRotinaViaJson() async {
    // Abre seletor de arquivos
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();

      try {
        final List<dynamic> acoes = json.decode(content);
        _mostrarMensagem('Executando comandos do arquivo JSON...');

        for (var acao in acoes) {
          final int tempo = acao['tempo'] ?? 500;

          // Cada chave pode conter um comando para uma função específica
          if (acao.containsKey('horizontal') && arduino1 != null) {
            arduino1!.enviarComando(acao['horizontal']);
            await Future.delayed(Duration(milliseconds: tempo));
          }

          if (acao.containsKey('vertical') && arduino2 != null) {
            arduino2!.enviarComando(acao['vertical']);
            await Future.delayed(Duration(milliseconds: tempo));
          }

          if (acao.containsKey('plataforma') && arduino3 != null) {
            arduino3!.enviarComando(acao['plataforma']);
            await Future.delayed(Duration(milliseconds: tempo));
          }

          if (acao.containsKey('botao1') && arduino1 != null) {
            arduino1!.enviarComando(acao['botao1']);
            await Future.delayed(Duration(milliseconds: tempo));
          }

          if (acao.containsKey('botao2') && arduino2 != null) {
            arduino2!.enviarComando(acao['botao2']);
            await Future.delayed(Duration(milliseconds: tempo));
          }
        }

        _mostrarMensagem('Execução via JSON concluída!');
      } catch (e) {
        _mostrarMensagem('Erro ao ler o JSON: $e');
      }
    } else {
      _mostrarMensagem('Nenhum arquivo selecionado.');
    }
  }

  // Limpa todos os comandos gravados
  void _excluirRotina() {
    setState(() {
      comandosGravados.clear();
    });

    _mostrarMensagem('Rotina excluída com sucesso!');
  }

  // Fecha as portas seriais ao sair
  @override
  void dispose() {
    arduino1?.fecharPorta();
    arduino2?.fecharPorta();
    arduino3?.fecharPorta();
    super.dispose();
  }

  // Constrói a interface para selecionar portas e conectar
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
          onPressed: () => _conectar(numero), // Chama _conectar()
          icon: const Icon(Icons.usb),
          label: const Text('Conectar'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Botões de controle e ações
  Widget _botoesComando() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(onPressed: () => _enviarParaTodos('w', gravar: true), child: const Text('W (Frente)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('x', gravar: true), child: const Text('X (Trás)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('a', gravar: true), child: const Text('A (Esquerda)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('d', gravar: true), child: const Text('D (Direita)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('c', gravar: true), child: const Text('C (Cima)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('b', gravar: true), child: const Text('B (Baixo)')),
        ElevatedButton(onPressed: () => _enviarParaTodos('s', gravar: true), child: const Text('S (Parar)')),
        ElevatedButton(onPressed: _executarRotina, child: const Text('Executar Rotina')),
        ElevatedButton(onPressed: _excluirRotina, child: const Text('Excluir Rotina')),
        ElevatedButton(onPressed: _executarRotinaViaJson, child: const Text('Executar Rotina Via JSON')),
      ],
    );
  }

  // Layout principal da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle Arduino Múltiplo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _seletorPorta(1, porta1, (porta) => setState(() => porta1 = porta)),
              _seletorPorta(2, porta2, (porta) => setState(() => porta2 = porta)),
              _seletorPorta(3, porta3, (porta) => setState(() => porta3 = porta)),
              const SizedBox(height: 20),
              _botoesComando(), // Exibe todos os botões de controle
            ],
          ),
        ),
      ),
    );
  }
}
