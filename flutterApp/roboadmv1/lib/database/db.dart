import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dtb_robo_adm.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_createAcaoRobo);
    await db.execute(_insereAcoesIniciais);
    await db.execute(_createRotina);
    await db.execute(_createExecRotina);
    await db.execute(_insertExemplo);
    await db.execute(_insertExemplo2);
  }

  String get _createAcaoRobo => '''
    CREATE  
    ---DROP
    TABLE
    ADM_ACAO_ROBO
     (
      ID_ACAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ACAO VARCHAR(100),
      NOME VARCHAR(200),
      DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INT
    );
''';

  String get _insereAcoesIniciais => '''
    INSERT INTO 
    --SELECT * FROM
    ADM_ACAO_ROBO 
    (ACAO, NOME)
    VALUES('w','Frente'),('x','Trás'),('a','Esquerda'),('d','Direita');
''';

  String get _createRotina => '''
    CREATE
    ---DROP
    TABLE
    ADM_ROTINAS
     (
      ID_ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
      NOME VARCHAR(200) NOT NULL,
      ATIVO CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      EDITAVEL CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      DT_CRIACAO_UNIX_MICROSSEGUNDOS INT NOT NULL DEFAULT (CAST((julianday('now') - 2440587.5) * 86400.0 * 1000 AS INTEGER)*1000),
      DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INT
    );
  ''';

  String get _createExecRotina => '''
    CREATE 
    ---DROP
    TABLE ADM_EXECUCAO_ROTINAS 
    (
      ID_EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ID_ROTINA INTEGER NOT NULL,
      ACAO VARCHAR(100),
      QTD_SINAIS INT,
      DT_EXECUCAO_UNIX_MICROSSEGUNDOS INT NOT NULL,  
      DT_EXCLUSAO_UNIX_MICROSSEGUNDOS INT,
      FOREIGN KEY (ACAO) REFERENCES ADM_ACAO_ROBO(ACAO),
      FOREIGN KEY (ID_ROTINA) REFERENCES ADM_ROTINAS(ID_ROTINA)
    );
''';

  String get _insertExemplo => '''
    INSERT INTO 
    --SELECT * FROM
    ADM_ROTINAS
    (NOME, ATIVO, EDITAVEL)
    VALUES('TESTE1 DE ROTINA', 'S', 'S'),('TESTE2 DE ROTINA', 'S', 'S'),('TESTE3 DE ROTINA', 'S', 'S');
  ''';

  String get _insertExemplo2 => '''
    INSERT INTO 
    --SELECT * FROM
    ADM_EXECUCAO_ROTINAS
    (ID_ROTINA, QTD_SINAIS, ACAO, DT_EXECUCAO_UNIX_MICROSSEGUNDOS)
    VALUES
       (1, 20, 'w', (CAST((julianday('now') - 2440587.5) * 86400.0 * 1000 AS INTEGER)*1000))
      ,(1, 30, 'w', (CAST((julianday('now') - 2440587.5) * 86400.0 * 1000 AS INTEGER)*1000))
      ,(3, 50, 's', (CAST((julianday('now') - 2440587.5) * 86400.0 * 1000 AS INTEGER)*1000));
  ''';

  static Future<int> createItem(
      String nome, String ativo, String editavel) async {
    final db = await instance.database;

    final data = {'NOME': nome, 'ATIVO': ativo, 'EDITAVEL': editavel};
    final id = await db.insert('ADM_ROTINAS', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> insertExecucaoRotina(
      int idRotina, String acao, int qtdSinais) async {
    final db = await instance.database;
    final data = {
      'ID_ROTINA': idRotina,
      'ACAO': acao,
      'QTD_SINAIS': qtdSinais,
      'DT_EXECUCAO_UNIX_MICROSSEGUNDOS': DateTime.now().millisecondsSinceEpoch *
          1000, // Unix timestamp em microssegundos
    };
    final id = await db.insert('ADM_EXECUCAO_ROTINAS', data);
    return id;
  }

  static Future<int> deleteItem(int rotina) async {
    final db = await instance.database;
    const dtAtual =
        "(CAST((julianday('now') - 2440587.5) * 86400.0 * 1000 AS INTEGER)*1000)";
    final id = await db.transaction((txn) async {
      final countRotinas = await txn.update(
        'ADM_ROTINAS',
        {'DT_EXCLUSAO_UNIX_MICROSSEGUNDOS': dtAtual},
        where: 'ID_ROTINA = ?',
        whereArgs: [rotina],
      );
      final countExecucaoRotinas = await txn.update(
        'ADM_EXECUCAO_ROTINAS',
        {'DT_EXCLUSAO_UNIX_MICROSSEGUNDOS': dtAtual},
        where: 'ID_ROTINA = ?',
        whereArgs: [rotina],
      );

      return countRotinas +
          countExecucaoRotinas; // Retorna o total de linhas deletadas
    });

    // final id = await db.delete(
    //   'ADM_ROTINAS',
    //   where: 'ROTINA = ?',
    //   whereArgs: [ROTINA],

    // );

    return id;
  }

  Future<List<Map<String, dynamic>>> getRotinas() async {
    final db = await instance.database;
    return await db.query('ADM_ROTINAS',
        where: 'DT_EXCLUSAO_UNIX_MICROSSEGUNDOS IS NULL', orderBy: "ID_ROTINA");
  }

  

  Future<List<Map<String, dynamic>>> getExecucaoRotinas(int rotinaId) async {
    final db = await instance.database;
    return await db.query(
      'ADM_EXECUCAO_ROTINAS',
      where: 'ID_ROTINA = ? AND DT_EXCLUSAO_UNIX_MICROSSEGUNDOS IS NULL',
      whereArgs: [rotinaId],
      orderBy: "DT_EXECUCAO_UNIX_MICROSSEGUNDOS",
    );
  }

}
