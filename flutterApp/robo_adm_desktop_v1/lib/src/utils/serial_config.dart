import 'package:flutter_libserialport/flutter_libserialport.dart';

String exibeConsole(porta) {
  // if (!porta.openReadWrite()) {
  //   return 'Não foi possivel abrir a porta ${porta}';
  // } else {
  //   return 'Porta ${porta} aberta.';
  // }
  final reader = SerialPortReader(port);
  reader.stream.listen((data) {
    return 'Dados Recebidos: ${String.fromCharCodes(data)}';
  })
}
