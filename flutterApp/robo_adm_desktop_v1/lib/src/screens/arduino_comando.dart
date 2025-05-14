import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ArduinoComando {
  late final SerialPort _porta;
  final int timeoutMs;

  ArduinoComando(String portaName, {this.timeoutMs = 3000}) {
    _porta = SerialPort(portaName);
    _porta.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none;
  }

  bool conectar() {
    return _porta.open(mode: SerialPortMode.readWrite);
  }

  void fecharPorta() {
    if (_porta.isOpen) {
      _porta.close();
    }
  }

  Future<void> enviarComando(String comando) async {
    if (_porta.isOpen) {
      final Uint8List dados = Uint8List.fromList(utf8.encode(comando));
      _porta.write(dados);
      if (kDebugMode) {
        print('Comando enviado: $comando');
      }
      await Future.delayed(const Duration(milliseconds: 100)); // Aguarda um pequeno tempo para garantir que o comando foi enviado
    } else {
      if (kDebugMode) {
        print('Erro: Porta não está aberta para enviar comando!');
      }
    }
  }

  Future<bool> _aguardarOK(StringBuffer buffer) async {
    final start = DateTime.now();
    while (!buffer.toString().contains('OK')) {
      if (DateTime.now().difference(start).inMilliseconds > timeoutMs) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return true;
  }

  Future<void> executarComandos(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        if (kDebugMode) print('Arquivo não encontrado em: $path');
        return;
      }

      final jsonString = await file.readAsString();
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is! List) {
        if (kDebugMode) print('JSON inválido: esperado uma lista de comandos.');
        return;
      }

      if (!_porta.isOpen && !conectar()) {
        if (kDebugMode) print('Falha ao abrir a porta serial.');
        return;
      }

      final reader = SerialPortReader(_porta);
      final buffer = StringBuffer();
      final subscription = reader.stream.listen((data) {
        final texto = utf8.decode(data);
        buffer.write(texto);
      });

      for (var item in decoded) {
        if (item is! Map) {
          if (kDebugMode) print('Item inválido no JSON: $item');
          continue;
        }

        final int tempo = (item['tempo'] is int) ? item['tempo'] : 500;
        final String? horizontal = item['horizontal'];
        final String? vertical = item['vertical'];
        final String? plataforma = item['plataforma'];
        final String? tomada1 = item['tomada1'];
        final String? tomada2 = item['tomada2'];

        // Envia os comandos existentes
        for (var comando in [horizontal, vertical, plataforma, tomada1, tomada2]) {
          if (comando != null && comando.isNotEmpty) {
            buffer.clear();
            enviarComando(comando);

            final sucesso = await _aguardarOK(buffer);
            if (!sucesso && kDebugMode) {
              print('Timeout esperando OK para comando: $comando');
            }
            await Future.delayed(Duration(milliseconds: tempo));
          }
        }
      }

      await subscription.cancel();
      fecharPorta();
    } catch (e) {
      if (kDebugMode) print('Erro ao executar comandos: $e');
      fecharPorta();
    }
  }
}
