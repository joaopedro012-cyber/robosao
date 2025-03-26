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

  bool conexaoAtiva = false;
  late SerialPort porta;

  void alterarConfiguracaoPorta(String objeto, String? novaPorta) {
    configuracoesPortas[objeto] = novaPorta;
    statusConexao[objeto] = false; // Reinicia o status ao alterar a porta
    notifyListeners();
  }

  String? obterPortaSelecionada(String objeto) {
    return configuracoesPortas[objeto];
  }

  void iniciarConexao() {
    try {
      bool algumaConexaoBemSucedida = false;

      configuracoesPortas.forEach((key, value) {
        if ((value ?? '').isNotEmpty) {
          try {
            porta = SerialPort(value!);
            inicializadorSerialPort(porta);
            statusConexao[key] = true;
            algumaConexaoBemSucedida = true;
          } catch (e) {
            statusConexao[key] = false;
            if (kDebugMode) print("Erro ao conectar na porta $key: $e");
          }
        }
      });

      conexaoAtiva = algumaConexaoBemSucedida;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Erro ao iniciar conexão: $e');
    }
  }

  void fecharConexao() {
    try {
      if (conexaoAtiva) {
        porta.close();
        conexaoAtiva = false;
        statusConexao.updateAll((key, value) => false);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao fechar conexão: $e');
    }
  }
}

void inicializadorSerialPort(SerialPort porta) {
  porta.open(mode: SerialPortMode.readWrite);
}