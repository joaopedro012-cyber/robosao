class InitModule {
  bool sensoresConfigurados = false;
  bool motoresConfigurados = false;

  Future<void> configurarSensores() async {
    // Lógica para configurar sensores
    sensoresConfigurados = true;
    print('Sensores configurados com sucesso!');
  }

  Future<void> configurarMotores() async {
    // Lógica para configurar motores
    motoresConfigurados = true;
    print('Motores configurados com sucesso!');
  }

  Future<void> inicializarSistema() async {
    await configurarSensores();
    await configurarMotores();
    print('Sistema inicializado com sucesso!');
  }
}
