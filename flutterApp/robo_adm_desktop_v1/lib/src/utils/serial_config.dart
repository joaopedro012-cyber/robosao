import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:async';

void inicializadorSerialPort(final SerialPort portaConexao) {
  portaConexao.openReadWrite();
  portaConexao.config = SerialPortConfig()
    ..baudRate = 9600
    ..bits = 8
    ..stopBits = 1
    ..parity = SerialPortParity.none
    ..setFlowControl(SerialPortFlowControl.none);
  if (kDebugMode) {
    print('INICIALIZOU A PORTA');
  }
}

void enviaDadosSerialPort(
    final SerialPort portaConexao, String textoParaEnviar) {
  portaConexao.write(Uint8List.fromList(textoParaEnviar.codeUnits));
  if (kDebugMode) {
    print('ENVIOU DADO');
  }
}

Future<String> exibeDadosSerialPort(final SerialPort portaConexao) async {
  SerialPortReader reader = SerialPortReader(portaConexao);
  Completer<String> completer = Completer<String>();
  reader.stream.listen((data) {
    String received = String.fromCharCodes(data);
    if (!completer.isCompleted) {
      completer.complete(received);
    }
  }, onError: (error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  });
  if (kDebugMode) {
    print('Exibido ${await completer.future}');
  }
  return completer.future;
}

void finalizacaoSerialPort(final SerialPort portaConexao, Timer temporizador) {
  portaConexao.close();
  portaConexao.dispose();
  temporizador.cancel();
}
