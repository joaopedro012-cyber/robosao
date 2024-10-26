import 'package:flutter/foundation.dart'; 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'AplicativoRobo.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE rotinas (
        ID_ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
        NOME TEXT,
        DESCRICAO TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE ADM_EXECUCAO_ROTINAS (
        ID_EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
        ID_ROTINA INTEGER,
        ACAO_HORIZONTAL TEXT,
        QTD_HORIZONTAL INTEGER,
        ACAO_VERTICAL TEXT,
        QTD_VERTICAL INTEGER,
        ACAO_PLATAFORMA TEXT,
        QTD_PLATAFORMA INTEGER,
        ACAO_BOTAO1 TEXT,
        QTD_BOTAO1 INTEGER,
        ACAO_BOTAO2 TEXT,
        QTD_BOTAO2 INTEGER,
        ACAO_BOTAO3 TEXT,
        QTD_BOTAO3 INTEGER,
        DT_EXECUCAO_UNIX_MICROSSEGUNDOS INTEGER,
        DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INTEGER,
        FOREIGN KEY(ID_ROTINA) REFERENCES rotinas(ID_ROTINA)
      )
    ''');

    await db.execute(''' 
      CREATE TABLE ADM_ACAO_ROBO (
        ID_ACAO INTEGER PRIMARY KEY AUTOINCREMENT,
        ACAO TEXT,
        NOME TEXT,
        DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INTEGER
      )
    ''');
 
    await db.execute('''
      INSERT INTO ADM_ACAO_ROBO (ACAO, NOME)
      VALUES ('w', 'Frente'), ('x', 'Trás'), ('a', 'Esquerda'), ('d', 'Direita');
    ''');

    await insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE rotinas ADD COLUMN ATIVO TEXT DEFAULT "S"');
    }
  }

  Future<void> insertInitialData(Database db) async {
    // Verifica se já existem rotinas para evitar duplicação
    final List<Map<String, dynamic>> existingRotinas = await db.query('rotinas');
    if (existingRotinas.isEmpty) {
      await db.execute('''
        INSERT INTO rotinas (NOME, DESCRICAO)
        VALUES ('TESTE1 DE ROTINA', 'Descrição da rotina 1'),
               ('TESTE2 DE ROTINA', 'Descrição da rotina 2'),
               ('TESTE3 DE ROTINA', 'Descrição da rotina 3');
      ''');
    }

    // Verifica se já existem execuções para evitar duplicação
    final List<Map<String, dynamic>> existingExecucoes = await db.query('ADM_EXECUCAO_ROTINAS');
    if (existingExecucoes.isEmpty) {
      List<Map<String, dynamic>> execucoesIniciais = [
        {'ID_ROTINA': 1, 'QTD_SINAIS': 20, 'ACAO': 'w'},
        {'ID_ROTINA': 1, 'QTD_SINAIS': 30, 'ACAO': 'w'},
        {'ID_ROTINA': 3, 'QTD_SINAIS': 50, 'ACAO': 's'},
      ];

      for (var execucao in execucoesIniciais) {
  await db.execute('''
    INSERT INTO ADM_EXECUCAO_ROTINAS (ID_ROTINA, QTD_HORIZONTAL, ACAO_HORIZONTAL, DT_EXECUCAO_UNIX_MICROSSEGUNDOS)
    VALUES (${execucao['ID_ROTINA']}, ${execucao['QTD_SINAIS']}, '${execucao['ACAO']}', 
      (strftime('%s', 'now') * 1000000));
  ''');
  }
    }
  }

  Future<void> insertRotina(String nome, String descricao) async {
    final db = await instance.database;
    if (nome.isEmpty || descricao.isEmpty) {
      throw Exception("Nome e descrição não podem ser vazios.");
    }
    await db.insert('rotinas', {
      'NOME': nome,
      'DESCRICAO': descricao,
    });
  }

  Future<void> updateRotina(int idRotina, String nome, String descricao) async {
    final db = await instance.database;
    if (idRotina <= 0 || nome.isEmpty || descricao.isEmpty) {
      throw Exception("ID da rotina deve ser maior que zero e nome/descrição não podem ser vazios.");
    }
    await db.update(
      'rotinas',
      {'NOME': nome, 'DESCRICAO': descricao},
      where: 'ID_ROTINA = ?',
      whereArgs: [idRotina],
    );
  }

  Future<void> deleteRotina(int idRotina) async {
    if (idRotina <= 0) throw Exception("ID da rotina deve ser maior que zero.");

    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('ADM_EXECUCAO_ROTINAS', where: 'ID_ROTINA = ?', whereArgs: [idRotina]);
      await txn.delete('rotinas', where: 'ID_ROTINA = ?', whereArgs: [idRotina]);
    });
  }

  Future<void> insertExecucaoRotina({
    required int idRotina,
    required String acaoHorizontal,
    required int qtdHorizontal,
    required String acaoVertical,
    required int qtdVertical,
    required String acaoPlataforma,
    required int qtdPlataforma,
    required String acaoBotao1,
    required int qtdBotao1,
    required String acaoBotao2,
    required int qtdBotao2,
    required String acaoBotao3,
    required int qtdBotao3,
    required int dtExecucao,
    int? dtExclusao,
  }) async {
    final db = await instance.database;

    if (idRotina <= 0 || acaoHorizontal.isEmpty || acaoVertical.isEmpty || 
        acaoPlataforma.isEmpty || qtdHorizontal < 0 || qtdVertical < 0 || 
        qtdPlataforma < 0 || qtdBotao1 < 0 || qtdBotao2 < 0 || qtdBotao3 < 0) {
      throw Exception("Dados inválidos para inserção.");
    }

    await db.insert('ADM_EXECUCAO_ROTINAS', {
      'ID_ROTINA': idRotina,
      'ACAO_HORIZONTAL': acaoHorizontal,
      'QTD_HORIZONTAL': qtdHorizontal,
      'ACAO_VERTICAL': acaoVertical,
      'QTD_VERTICAL': qtdVertical,
      'ACAO_PLATAFORMA': acaoPlataforma,
      'QTD_PLATAFORMA': qtdPlataforma,
      'ACAO_BOTAO1': acaoBotao1,
      'QTD_BOTAO1': qtdBotao1,
      'ACAO_BOTAO2': acaoBotao2,
      'QTD_BOTAO2': qtdBotao2,
      'ACAO_BOTAO3': acaoBotao3,
      'QTD_BOTAO3': qtdBotao3,
      'DT_EXECUCAO_UNIX_MICROSSEGUNDOS': dtExecucao,
      'DT_EXCLUSAO_UNIX_MICROSSEGUNDOS': dtExclusao ?? 0,
    });
  }

  Future<void> updateExecucaoRotina(int idExecucao, {
    required String acaoHorizontal,
    required int qtdHorizontal,
    required String acaoVertical,
    required int qtdVertical,
    required String acaoPlataforma,
    required int qtdPlataforma,
    required String acaoBotao1,
    required int qtdBotao1,
    required String acaoBotao2,
    required int qtdBotao2,
    required String acaoBotao3,
    required int qtdBotao3,
  }) async {
    final db = await instance.database;

    if (idExecucao <= 0 || acaoHorizontal.isEmpty || acaoVertical.isEmpty || 
        acaoPlataforma.isEmpty || qtdHorizontal < 0 || qtdVertical < 0 || 
        qtdPlataforma < 0 || qtdBotao1 < 0 || qtdBotao2 < 0 || qtdBotao3 < 0) {
      throw Exception("Dados inválidos para atualização.");
    }

    await db.update(
      'ADM_EXECUCAO_ROTINAS',
      {
        'ACAO_HORIZONTAL': acaoHorizontal,
        'QTD_HORIZONTAL': qtdHorizontal,
        'ACAO_VERTICAL': acaoVertical,
        'QTD_VERTICAL': qtdVertical,
        'ACAO_PLATAFORMA': acaoPlataforma,
        'QTD_PLATAFORMA': qtdPlataforma,
        'ACAO_BOTAO1': acaoBotao1,
        'QTD_BOTAO1': qtdBotao1,
        'ACAO_BOTAO2': acaoBotao2,
        'QTD_BOTAO2': qtdBotao2,
        'ACAO_BOTAO3': acaoBotao3,
        'QTD_BOTAO3': qtdBotao3,
      },
      where: 'ID_EXECUCAO = ?',
      whereArgs: [idExecucao],
    );
  }

  Future<void> deleteExecucaoRotina(int idExecucao) async {
    final db = await instance.database;
    if (idExecucao <= 0) {
      throw Exception("ID da execução deve ser maior que zero.");
    }
    await db.delete('ADM_EXECUCAO_ROTINAS', where: 'ID_EXECUCAO = ?', whereArgs: [idExecucao]);
  }

 Future<void> deleteAcao(int idAcao) async {
  await deleteExecucaoRotina(idAcao); 
}

  Future<List<Map<String, dynamic>>> getRotinas() async {
    final db = await instance.database;
    return await db.query('rotinas');
  }

  Future<List<Map<String, dynamic>>> getExecucoesRotina(int idRotina) async {
    final db = await instance.database;
    return await db.query('ADM_EXECUCAO_ROTINAS', where: 'ID_ROTINA = ?', whereArgs: [idRotina]);
  }

  Future<List<Map<String, dynamic>>> getAcoesRobos() async {
    final db = await instance.database; 
    return await db.query('ADM_ACAO_ROBO');
  }
  
  Future <void> insertAcao({ 
    required int idRotina,
    required String acaoHorizontal,
    required String acaoVertical,
    required String acaoPlataforma,
    required String acaoBotao1,
    required String acaoBotao2,
    required String acaoBotao3,
    required int qtdHorizontal,
    required int qtdVertical,
    required int qtdPlataforma,
    required int qtdBotao1,
    required int qtdBotao2,
    required int qtdBotao3,
    required int dtExecucao,
  }) async {
    if (kDebugMode) {
      print('Inserindo ação: $acaoHorizontal, $acaoVertical, $acaoPlataforma');
    }
    await insertExecucaoRotina(
      idRotina: idRotina,
      acaoHorizontal: acaoHorizontal,
      qtdHorizontal: qtdHorizontal,
      acaoVertical: acaoVertical,
      qtdVertical: qtdVertical,
      acaoPlataforma: acaoPlataforma,
      qtdPlataforma: qtdPlataforma,
      acaoBotao1: acaoBotao1,
      qtdBotao1: qtdBotao1,
      acaoBotao2: acaoBotao2,
      qtdBotao2: qtdBotao2,
      acaoBotao3: acaoBotao3,
      qtdBotao3: qtdBotao3,
      dtExecucao: dtExecucao,
    );
  }
}