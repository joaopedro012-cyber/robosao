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
      final String comandoFinal = '$comando\n'; // <-- ADICIONA \n
      final Uint8List dados = Uint8List.fromList(utf8.encode(comandoFinal));
      final bytesEscritos = _porta.write(dados);
      if (bytesEscritos != dados.length) {
        if (kDebugMode) {
          print('Aviso: Nem todos os bytes foram escritos na porta.');
        }
      }
      if (kDebugMode) {
        print('Comando enviado: $comandoFinal');
      }
      await Future.delayed(const Duration(milliseconds: 100));
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
        return false; // Timeout
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return true; // Recebeu OK
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

      if (decoded is! Map) {
        if (kDebugMode) print('JSON inválido: esperado um objeto com "acoes".');
        return;
      }

      final List<dynamic>? acoes = decoded['acoes'];
      if (acoes == null || acoes.isEmpty) {
        if (kDebugMode) print('Nenhuma ação encontrada no JSON.');
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
        if (kDebugMode) print('Recebido da serial: $texto');
      });

      int? ultimoTimestampMicros;

      for (var item in acoes) {
        if (item is! Map) {
          if (kDebugMode) print('Item inválido na lista de ações: $item');
          continue;
        }

        final int? timestampMicros = item['dt_execucao_unix_microssegundos'] is int
            ? item['dt_execucao_unix_microssegundos']
            : null;

        if (ultimoTimestampMicros != null && timestampMicros != null) {
          final int diffMicros = timestampMicros - ultimoTimestampMicros;
          if (diffMicros > 0) {
            if (kDebugMode) print('Aguardando $diffMicros microssegundos antes do próximo comando.');
            await Future.delayed(Duration(microseconds: diffMicros));
          }
        }

        ultimoTimestampMicros = timestampMicros;

        final comandos = <String>[
          item['acao_horizontal'] ?? '',
          item['acao_vertical'] ?? '',
          item['acao_plataforma'] ?? '',
          item['botao1'] ?? '',
          item['botao2'] ?? '',
          item['botao3'] ?? '',
        ];

        for (var comando in comandos.where((c) => c.isNotEmpty)) {
          buffer.clear();
          await enviarComando(comando);

          final sucesso = await _aguardarOK(buffer);
          if (!sucesso && kDebugMode) {
            print('Timeout esperando OK para comando: $comando');
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
