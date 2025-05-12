// Classe que inicializa e configura sensores e motores
class InitModule {
  // Flags para verificar se os sensores e motores foram configurados
  bool sensoresConfigurados = false;
  bool motoresConfigurados = false;

  // Método assíncrono para configurar os sensores
  Future<void> configurarSensores() async {
    // Lógica para configurar os sensores (aqui você adicionaria o código necessário)
    sensoresConfigurados = true;  // Marca os sensores como configurados
    print('Sensores configurados com sucesso!');  // Imprime a mensagem de sucesso
  }

  // Método assíncrono para configurar os motores
  Future<void> configurarMotores() async {
    // Lógica para configurar os motores (aqui você adicionaria o código necessário)
    motoresConfigurados = true;  // Marca os motores como configurados
    print('Motores configurados com sucesso!');  // Imprime a mensagem de sucesso
  }

  // Método assíncrono para inicializar o sistema
  Future<void> inicializarSistema() async {
    await configurarSensores();  // Chama o método para configurar os sensores
    await configurarMotores();   // Chama o método para configurar os motores
    print('Sistema inicializado com sucesso!');  // Imprime a mensagem de sucesso
  }
}
