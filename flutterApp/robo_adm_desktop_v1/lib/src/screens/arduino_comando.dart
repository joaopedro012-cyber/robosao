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
    if (_porta.isOpen) {
      if (kDebugMode) print('Porta já está aberta.');
      return true;
    }
    final openSuccess = _porta.open(mode: SerialPortMode.readWrite);
    if (!openSuccess) {
      if (kDebugMode) print('Falha ao abrir a porta serial: ${SerialPort.lastError}');
    }
    return openSuccess;
  }

  void fecharPorta() {
    if (_porta.isOpen) {
      _porta.close();
      if (kDebugMode) print('Porta serial fechada.');
    }
  }

  Future<void> enviarComando(String comando) async {
    if (!_porta.isOpen) {
      if (kDebugMode) print('Erro: Porta não está aberta para enviar comando!');
      return;
    }

    final String comandoFinal = '$comando\r\n';
    final Uint8List dados = Uint8List.fromList(utf8.encode(comandoFinal));

    try {
      final bytesEscritos = _porta.write(dados);
      if (bytesEscritos != dados.length) {
        if (kDebugMode) print('Aviso: Nem todos os bytes foram escritos na porta.');
      }
      if (kDebugMode) print('Comando enviado: $comandoFinal');
    } catch (e) {
      if (kDebugMode) print('Erro ao enviar comando: $e');
    }

    await Future.delayed(const Duration(milliseconds: 150));
  }

  Future<bool> _aguardarOK(StringBuffer buffer) async {
    final start = DateTime.now();
    while (true) {
      if (buffer.toString().contains('OK')) return true;
      if (DateTime.now().difference(start).inMilliseconds > timeoutMs) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
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

      final DateTime tempoInicialSistema = DateTime.now();
      final int? tempoInicialJson = (acoes.first['dt_execucao_unix_microssegundos'] is int)
          ? acoes.first['dt_execucao_unix_microssegundos']
          : null;

      if (tempoInicialJson == null) {
        if (kDebugMode) print('O primeiro comando não tem timestamp válido.');
        await subscription.cancel();
        fecharPorta();
        return;
      }

      for (var item in acoes) {
        if (item is! Map) continue;

        final int? timestampMicros = item['dt_execucao_unix_microssegundos'];
        if (timestampMicros == null) continue;

        // Verifica se todos os comandos estão vazios
        final todosComandosVazios = [
          item['acao_horizontal'],
          item['acao_vertical'],
          item['acao_plataforma'],
          item['botao1'],
          item['botao2'],
        ].every((c) => c == null || c.toString().trim().isEmpty);

        if (todosComandosVazios) {
          if (kDebugMode) print('Ação ignorada: todos os comandos estão vazios.');
          continue;
        }

        final int diffMicros = timestampMicros - tempoInicialJson;
        final DateTime tempoAlvo = tempoInicialSistema.add(Duration(microseconds: diffMicros));
        final Duration delayRestante = tempoAlvo.difference(DateTime.now());

        if (delayRestante.inMicroseconds > 0) {
          if (kDebugMode) {
            print('Aguardando ${delayRestante.inMicroseconds} microssegundos...');
          }
          await Future.delayed(delayRestante);
        }

        final comandos = <String>[
          item['acao_horizontal'] ?? '',
          item['acao_vertical'] ?? '',
          item['acao_plataforma'] ?? '',
          item['botao1'] ?? '',
          item['botao2'] ?? '',
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
