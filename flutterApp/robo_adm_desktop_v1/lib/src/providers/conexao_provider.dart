import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ConexaoProvider extends ChangeNotifier {
  final Map<String, String?> configuracoesPortas = {
    'Sensores': null,
    'Motores Horizontal': null,
    'Motores Vertical': null,
    'Plataforma': null,
    'Botões Plataforma': null,
  };

  final Map<String, bool> statusConexao = {
    'Sensores': false,
    'Motores Horizontal': false,
    'Motores Vertical': false,
    'Plataforma': false,
    'Botões Plataforma': false,
  };

  final Map<String, SerialPort> portasAtivas = {};

  bool get conexaoAtiva => statusConexao.values.any((status) => status);

  void alterarConfiguracaoPorta(String objeto, String? novaPorta) {
    configuracoesPortas[objeto] = novaPorta;
    statusConexao[objeto] = false; // Reinicia o status ao alterar a porta
    notifyListeners();
  }

  String? obterPortaSelecionada(String objeto) {
    return configuracoesPortas[objeto];
  }

  Future<void> iniciarConexao() async {
    for (var entrada in configuracoesPortas.entries) {
      final key = entrada.key;
      final portaSelecionada = entrada.value;

      if ((portaSelecionada ?? '').isNotEmpty) {
        try {
          final porta = SerialPort(portaSelecionada!);
          if (!porta.isOpen) {
            porta.open(mode: SerialPortMode.readWrite);
          }

          portasAtivas[key] = porta;
          statusConexao[key] = true;

        } catch (e) {
          statusConexao[key] = false;
          if (kDebugMode) {
            print('Erro ao conectar na porta [$key] ($portaSelecionada): $e');
          }
        }
      }
    }

    notifyListeners();
  }

  void fecharConexao() {
    for (var entry in portasAtivas.entries) {
      final key = entry.key;
      final porta = entry.value;

      if (porta.isOpen) {
        try {
          porta.close();
        } catch (e) {
          if (kDebugMode) {
            print('Erro ao fechar porta [$key]: $e');
          }
        }
      }

      statusConexao[key] = false;
    }

    portasAtivas.clear();
    notifyListeners();
  }

  Future<void> executarRotina(dynamic rotinaJson) async {
    // Exemplo de como você poderia distribuir comandos por porta
    for (var comando in rotinaJson) {
      final tipo = comando['tipo']; // Ex: "Motores Horizontal"
      final dados = comando['dados']; // Dados a serem enviados

      final porta = portasAtivas[tipo];
      if (porta != null && porta.isOpen) {
        final config = SerialPortConfig()
          ..baudRate = 9600
          ..bits = 8
          ..stopBits = 1
          ..parity = SerialPortParity.none;

        porta.config = config;

        final writer = porta.write(const Utf8Encoder().convert(dados.toString()));
        if (writer < 0) {
          if (kDebugMode) {
            print('Erro ao escrever para porta [$tipo]');
          }
        } else {
          if (kDebugMode) {
            print('Comando enviado para [$tipo]: $dados');
          }
        }

        // Pode adicionar await Future.delayed(...) aqui se quiser dar intervalo entre comandos
      }
    }
  }
}
