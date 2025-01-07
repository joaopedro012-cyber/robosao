import 'dart:io';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart'; // Importando a biblioteca

class ComunicacaoArduino {
  late SerialPort _port;
  late SerialPortReader _reader;

  // Função para identificar e abrir a primeira porta disponível
  void abrirPortaAutomaticamente() {
    List<String> portas = _listarPortasSeriais(); // Obtém uma lista de portas possíveis

    if (portas.isNotEmpty) {
      _port = SerialPort(portas[0]); // Seleciona a primeira porta disponível
      if (_port.openReadWrite()) {
        print("Porta Serial ${portas[0]} aberta com sucesso");
      } else {
        print("Erro ao abrir a porta serial ${portas[0]}");
      }

      // Iniciando o leitor para ler dados da porta serial
      _reader = SerialPortReader(_port);
      _reader.stream.listen((data) {
        // Convertendo o Uint8List para String
        String dadosRecebidos = utf8.decode(data);

        print("Dados recebidos do Arduino: $dadosRecebidos");

        // Aqui você pode processar as respostas do Arduino, como detectar obstáculos
        if (dadosRecebidos == "obstaculo_detectado") {
          print("Obstáculo detectado, interrompendo rotina...");
          // Interromper a execução da rotina
          // Você pode adicionar lógica aqui para gerenciar a interrupção
        }
      });
    } else {
      print("Nenhuma porta serial encontrada.");
    }
  }

  // Função para listar as portas seriais disponíveis (implementação manual)
  List<String> _listarPortasSeriais() {
    List<String> portas = [];

    // Defina as portas possíveis dependendo do sistema operacional
    if (Platform.isWindows) {
      // No Windows, as portas são geralmente "COM1", "COM2", etc.
      portas = List.generate(10, (index) => 'COM${index + 1}');
    } else if (Platform.isLinux) {
      // No Linux, as portas são geralmente "/dev/ttyUSB0", "/dev/ttyUSB1", etc.
      portas = List.generate(10, (index) => '/dev/ttyUSB$index');
    } else if (Platform.isMacOS) {
      // No MacOS, as portas são geralmente "/dev/tty.usbserial-xxxx"
      portas = List.generate(10, (index) => '/dev/tty.usbserial-$index');
    }

    return portas;
  }

  // Enviar um comando para o Arduino
  void enviarComando(String comando) {
    if (_port.isOpen) {
      // Converter o comando de String para Uint8List antes de enviar
      _port.write(Uint8List.fromList(comando.codeUnits));
    } else {
      print("Porta serial não está aberta");
    }
  }

  // Fechar a porta serial quando não for mais necessário
  void fecharPorta() {
    if (_port.isOpen) {
      _port.close();
      print("Porta Serial fechada.");
    }
  }
}

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});
  
  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  bool filledDisabled = false;
  ComunicacaoArduino comunicacao = ComunicacaoArduino(); // Instância da comunicação serial

  // Função para simular a execução da rotina
  void executarRotina(String caminhoArquivo) async {
    try {
      // Lê o arquivo JSON
      File arquivo = File(caminhoArquivo);
      String conteudo = await arquivo.readAsString();
      Map<String, dynamic> dadosJson = jsonDecode(conteudo);

      // Exibindo os sensores e automações configurados no arquivo JSON
      print("Sensores configurados:");
      for (var sensor in dadosJson['sensores']) {
        print(
            'Nome: ${sensor['nome']}, Diretorio: ${sensor['diretorio']}, Distância Mínima: ${sensor['distancia_minima']}');
      }

      print("\nAutomação configurada:");
      for (var device in dadosJson['automacao']) {
        print(
            'Nome: ${device['nome']}, Porta: ${device['porta']}, Ativo: ${device['ativo']}');
        if (device['ativo']) {
          // Enviar comando para ativar o dispositivo (motor, sensor, etc)
        }
      }

      // Iniciando a comunicação com o Arduino
      comunicacao.enviarComando('start_routine'); // Comando para o Arduino começar a rotina

      // Simulação de execução da rotina
      await Future.delayed(const Duration(seconds: 2));

      print("Rotina executada com sucesso!");
    } catch (e) {
      print("Erro ao executar a rotina: $e");
    }
  }

  // Função para logar exceções ou mensagens
  void logException(String message) {
    if (kDebugMode) {
      print(message);
    }
    GlobalKey<ScaffoldMessengerState>().currentState?.hideCurrentSnackBar();
    GlobalKey<ScaffoldMessengerState>().currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // Função para selecionar os arquivos e iniciar a execução
  void selecionaArquivos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        Directory diretoriosArquivo = await getApplicationDocumentsDirectory();
        String diretorioFinalCaminho = '${diretoriosArquivo.path}/Rotinas Robo';

        Directory diretorioFinal = Directory(diretorioFinalCaminho);
        if (!await diretorioFinal.exists()) {
          await diretorioFinal.create(recursive: true);
        }

        for (PlatformFile file in result.files) {
          if (file.extension == 'json') {
            File sourceFile = File(file.path!);
            String diretorioFinalArquivo =
                '$diretorioFinalCaminho/${file.name}';
            await sourceFile.copy(diretorioFinalArquivo);
            logException('Arquivo copiado com sucesso!');

            // Chama a função para iniciar a execução da rotina
            executarRotina(diretorioFinalArquivo);
          } else {
            logException('Arquivo ${file.name} não é um .json e foi ignorado.');
          }
        }
      }
    } on PlatformException catch (e) {
      logException('Unsupported operation: $e');
    } catch (e) {
      logException(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializa a comunicação com a porta serial automaticamente
    comunicacao.abrirPortaAutomaticamente();
  }

  @override
  void dispose() {
    super.dispose();
    // Fecha a comunicação com a porta serial quando a página for destruída
    comunicacao.fecharPorta();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: screenWidth * 0.35,
          child: Wrap(
            children: [
              SizedBox(
                width: screenWidth * 0.27,
                child: const fui.TextBox(
                  readOnly: true,
                  placeholder: 'Selecione a Rotina.json',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14.0,
                    color: Color(0xFF5178BE),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.08,
                child: FilledButton(
                  onPressed: () => selecionaArquivos(),
                  child: const Text('Selecionar'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.35,
          child: const fui.Expander(
              header: Text('Open to see'),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Text('A long Text Here'),
                ),
              )),
        ),
      ],
    );
  }
}
