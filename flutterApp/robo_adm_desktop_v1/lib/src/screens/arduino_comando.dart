import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ArduinoComando {
  late final SerialPort porta;
  final int timeoutMs;

  ArduinoComando(String portaName, {this.timeoutMs = 3000}) {
    porta = SerialPort(portaName);
    porta.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none;
  }

  bool conectar() {
  if (porta.isOpen) {
    print('[INFO] Porta já aberta.');
    return true;
  }

  final openSuccess = porta.open(mode: SerialPortMode.readWrite);
  if (!openSuccess) {
    print('[ERRO] Falha ao abrir a porta serial: ${SerialPort.lastError}');
  } else {
    print('[SUCESSO] Porta aberta com sucesso: ${porta.name}');
  }
  return openSuccess;
}


  void fecharPorta() {
    if (porta.isOpen) {
      porta.close();
      if (kDebugMode) print('Porta serial fechada.');
    }
  }

  Future<void> enviarComando(String comando) async {
    if (!porta.isOpen) {
      if (kDebugMode) print('Erro: Porta não está aberta para enviar comando!');
      return;
    }

    final String comandoFinal = '$comando\r\n';
    final Uint8List dados = Uint8List.fromList(utf8.encode(comandoFinal));

    try {
      final bytesEscritos = porta.write(dados);
      if (bytesEscritos != dados.length) {
        if (kDebugMode) print('Aviso: Nem todos os bytes foram escritos na porta.');
      }
      if (kDebugMode) print('Comando enviado: $comandoFinal');
    } catch (e) {
      if (kDebugMode) print('Erro ao enviar comando: $e');
    }
     await Future.delayed(const Duration(milliseconds: 50));
  }
}