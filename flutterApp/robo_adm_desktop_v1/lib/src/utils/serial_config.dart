import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:async';

// Função para inicializar a porta serial
void inicializadorSerialPort(final SerialPort portaConexao) {
  try {
    if (!portaConexao.openReadWrite()) {
      throw 'Não foi possível abrir a porta serial';
    }

    portaConexao.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none
      ..setFlowControl(SerialPortFlowControl.none);

    if (kDebugMode) {
      print('Porta serial inicializada com sucesso!');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao inicializar a porta serial: $e');
    }
  }
}

// Função para enviar dados para o Arduino via serial
void enviaDadosSerialPort(
    final SerialPort portaConexao, String textoParaEnviar) {
  try {
    if (portaConexao.isOpen) {
      portaConexao.write(Uint8List.fromList(textoParaEnviar.codeUnits));
      if (kDebugMode) {
        print('Dado enviado: $textoParaEnviar');
      }
    } else {
      throw 'A porta serial não está aberta';
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao enviar dados para a porta serial: $e');
    }
  }
}

// Função para exibir dados recebidos da porta serial
Future<String> exibeDadosSerialPort(final SerialPort portaConexao) async {
  final Completer<String> completer = Completer<String>();
  final reader = SerialPortReader(portaConexao);
  String received = '';

  // Escuta os dados que chegam da porta serial
  reader.stream.listen(
    (data) {
      // Converte os dados recebidos em uma string
      received = String.fromCharCodes(data);
      completer.complete(received);
      if (kDebugMode) {
        print('Dados recebidos: $received');
      }
    },
    onError: (error) {
      // Em caso de erro, completamos a execução com erro
      if (kDebugMode) {
        print('Erro ao ler dados: $error');
      }
      completer.completeError(error);
    },
    onDone: () {
      if (kDebugMode) {
        print('Leitura concluída');
      }
    },
  );

  // Retorna o resultado da leitura ou erro
  return completer.future;
}

// Função para finalizar a conexão serial
void finalizacaoSerialPort(final SerialPort portaConexao) {
  try {
    portaConexao.close();
    portaConexao.dispose();
    if (kDebugMode) {
      print('Conexão serial finalizada com sucesso.');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao finalizar a conexão serial: $e');
    }
  }
}
