import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:robo_adm_desktop_v1/src/screens/home.dart';
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
  final Completer<String> completer = Completer<String>();
  final reader = SerialPortReader(portaConexao);
  String received = "por hora nada";

  reader.stream.listen((data) {
    received = String.fromCharCodes(data);
    completer.complete(received);
    if (kDebugMode) {
      print('Exibido $received');
    }
  }, onError: (error) {
    print(error);
    completer.completeError(error);
  });

  return completer.future;
}

void finalizacaoSerialPort(final SerialPort portaConexao //, Timer temporizador
    ) {
  portaConexao.close();
  portaConexao.dispose();
  //temporizador.cancel();
}
