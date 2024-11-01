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
        id_rotina INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        ativo TEXT DEFAULT "S"
      )
    ''');

    await db.execute(''' 
      CREATE TABLE adm_execucao_rotinas (
        id_execucao INTEGER PRIMARY KEY AUTOINCREMENT,
        id_rotina INTEGER,
        acao_horizontal TEXT,
        qtd_horizontal INTEGER,
        acao_vertical TEXT,
        qtd_vertical INTEGER,
        acao_plataforma TEXT,
        qtd_plataforma INTEGER,
        acao_botao1 TEXT,
        qtd_botao1 INTEGER,
        acao_botao2 TEXT,
        qtd_botao2 INTEGER,
        acao_botao3 TEXT,
        qtd_botao3 INTEGER,
        dt_execucao_unix_microssegundos INTEGER,
        dt_exclusao_unix_microssegundos INTEGER,
        FOREIGN KEY(id_rotina) REFERENCES rotinas(id_rotina)
      )
    ''');

    await db.execute(''' 
      CREATE TABLE adm_acao_robo (
        id_acao INTEGER PRIMARY KEY AUTOINCREMENT,
        acao TEXT,
        nome TEXT,
        dt_exclusao_unix_microssegundos INTEGER
      )
    ''');

    await insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE rotinas ADD COLUMN ativo TEXT DEFAULT "S"');
    }
  }

  Future<void> insertInitialData(Database db) async {
    final List<Map<String, dynamic>> existingRotinas = await db.query('rotinas');
    if (existingRotinas.isEmpty) {
      await db.transaction((txn) async {
        await txn.insert('rotinas', {'nome': 'TESTE1 DE ROTINA', 'descricao': 'Descrição da rotina 1'});
        await txn.insert('rotinas', {'nome': 'TESTE2 DE ROTINA', 'descricao': 'Descrição da rotina 2'});
        await txn.insert('rotinas', {'nome': 'TESTE3 DE ROTINA', 'descricao': 'Descrição da rotina 3'});
      });
    }
    
    final List<Map<String, dynamic>> existingExecucoes = await db.query('adm_execucao_rotinas');
    if (existingExecucoes.isEmpty) {
      List<Map<String, dynamic>> execucoesIniciais = [
        {'id_rotina': 1, 'qtd_horizontal': 20, 'acao_horizontal': 'w'},
        {'id_rotina': 1, 'qtd_horizontal': 30, 'acao_horizontal': 'w'},
        {'id_rotina': 3, 'qtd_horizontal': 50, 'acao_horizontal': 's'},
      ];

      for (var execucao in execucoesIniciais) {
        await db.execute(''' 
          INSERT INTO adm_execucao_rotinas (id_rotina, qtd_horizontal, acao_horizontal, dt_execucao_unix_microssegundos)
          VALUES (${execucao['id_rotina']}, ${execucao['qtd_horizontal']}, '${execucao['acao_horizontal']}', 
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
      'nome': nome,
      'descricao': descricao,
    });
  }

  Future<void> updateRotina(int idRotina, String nome, String descricao) async {
    final db = await instance.database;
    if (idRotina <= 0 || nome.isEmpty || descricao.isEmpty) {
      throw Exception("ID da rotina deve ser maior que zero e nome/descrição não podem ser vazios.");
    }
    await db.update(
      'rotinas',
      {'nome': nome, 'descricao': descricao},
      where: 'id_rotina = ?',
      whereArgs: [idRotina],
    );
  }

  Future<void> deleteRotina(int idRotina) async {
    if (idRotina <= 0) throw Exception("ID da rotina deve ser maior que zero.");

    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('adm_execucao_rotinas', where: 'id_rotina = ?', whereArgs: [idRotina]);
      await txn.delete('rotinas', where: 'id_rotina = ?', whereArgs: [idRotina]);
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

    await db.insert('adm_execucao_rotinas', {
      'id_rotina': idRotina,
      'acao_horizontal': acaoHorizontal,
      'qtd_horizontal': qtdHorizontal,
      'acao_vertical': acaoVertical,
      'qtd_vertical': qtdVertical,
      'acao_plataforma': acaoPlataforma,
      'qtd_plataforma': qtdPlataforma,
      'acao_botao1': acaoBotao1,
      'qtd_botao1': qtdBotao1,
      'acao_botao2': acaoBotao2,
      'qtd_botao2': qtdBotao2,
      'acao_botao3': acaoBotao3,
      'qtd_botao3': qtdBotao3,
      'dt_execucao_unix_microssegundos': dtExecucao,
      'dt_exclusao_unix_microssegundos': dtExclusao ?? 0,
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
      'adm_execucao_rotinas',
      {
        'acao_horizontal': acaoHorizontal,
        'qtd_horizontal': qtdHorizontal,
        'acao_vertical': acaoVertical,
        'qtd_vertical': qtdVertical,
        'acao_plataforma': acaoPlataforma,
        'qtd_plataforma': qtdPlataforma,
        'acao_botao1': acaoBotao1,
        'qtd_botao1': qtdBotao1,
        'acao_botao2': acaoBotao2,
        'qtd_botao2': qtdBotao2,
        'acao_botao3': acaoBotao3,
        'qtd_botao3': qtdBotao3,
      },
      where: 'id_execucao = ?',
      whereArgs: [idExecucao],
    );
  }

  Future<void> deleteExecucaoRotina(int idExecucao) async {
    final db = await instance.database;
    if (idExecucao <= 0) {
      throw Exception("ID da execução deve ser maior que zero.");
    }
    await db.delete('adm_execucao_rotinas', where: 'id_execucao = ?', whereArgs: [idExecucao]);
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
    return await db.query('adm_execucao_rotinas', where: 'id_rotina = ?', whereArgs: [idRotina]);
  }

  Future<List<Map<String, dynamic>>> getAcoesRobos() async {
    final db = await instance.database; 
    return await db.query('adm_acao_robo');
  }
  
  Future<void> insertAcao({ 
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
