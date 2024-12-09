import 'dart:io';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});
  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  bool filledDisabled = false;

  // Função para simular a execução da rotina
  void executarRotina(String caminhoArquivo) async {
    try {
      // Lê o arquivo JSON
      File arquivo = File(caminhoArquivo);
      String conteudo = await arquivo.readAsString();
      Map<String, dynamic> dadosJson = jsonDecode(conteudo);

      // Aqui você pode fazer o que for necessário com os dados da rotina
      List sensores = dadosJson['sensores'];
      List automacao = dadosJson['automacao'];

      // Exibindo os sensores e automações configurados no arquivo JSON
      print("Sensores configurados:");
      for (var sensor in sensores) {
        print(
            'Nome: ${sensor['nome']}, Diretorio: ${sensor['diretorio']}, Distância Mínima: ${sensor['distancia_minima']}');
        // Aqui você pode implementar a lógica para acionar sensores
        // Por exemplo, se for um sensor de distância, iniciar leitura
        // exemplo: acionarSensor(sensor['diretorio']);
      }

      print("\nAutomação configurada:");
      for (var device in automacao) {
        print(
            'Nome: ${device['nome']}, Porta: ${device['porta']}, Ativo: ${device['ativo']}');
        // Aqui você pode implementar a lógica de controle de dispositivos
        // Por exemplo, se for um motor, enviar comando para mover o robô
        if (device['ativo']) {
          // Enviar comando para ativar o dispositivo (motor, sensor, etc)
          // exemplo: enviarComandoMotor(device['porta']);
        }
      }

      // Simulação de execução da rotina
      print('\nExecutando a rotina...');

      // Exemplo de interação com os motores
      await Future.delayed(const Duration(seconds: 2));

      // Aqui você deve chamar as funções reais para controlar o robô,
      // como por exemplo, enviar comandos para os motores
      // Exemplo de movimentação: moverParaFrente(), virarParaEsquerda()

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
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
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
  Widget build(BuildContext context) {
    // Agora você pode acessar o 'context' aqui
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
