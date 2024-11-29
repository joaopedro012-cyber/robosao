import 'dart:convert';

class Communication {
  void enviarComando(String comando) {
    // Simula envio de comando
    print('Comando enviado: $comando');
  }

  void receberDados(String dados) {
    // Simula recebimento de dados
    final decodificado = jsonDecode(dados);
    print('Dados recebidos: $decodificado');
  }
}
