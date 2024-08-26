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
  }

  String get _createAcaoRobo => '''
    CREATE TABLE ADM_ACAO_ROBO (
      ID_ACAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ACAO VARCHAR(100),
      NOME VARCHAR(200),
      DT_EXCLUSAO DATETIME
    );
''';

  String get _insereAcoesIniciais => '''
    INSERT INTO ADM_ACAO_ROBO (ACAO, NOME)
    VALUES('w','Frente'),('x','Trás'),('a','Esquerda'),('d','Direita');
''';

  String get _createRotina => '''
    CREATE TABLE ADM_ROTINAS (
      ID_ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
      NOME VARCHAR(200) NOT NULL,
      ATIVO CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      EDITAVEL CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      DT_CRIACAO TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
      DT_EXCLUSAO DATETIME
    );
  ''';

  String get _createExecRotina => '''
    CREATE TABLE ADM_EXECUCAO_ROTINAS (
      ID_EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ID_ROTINA INTEGER NOT NULL,
      ACAO VARCHAR(100),
      QTD_SINAIS INT,
      DT_EXECUCAO DATETIME NOT NULL,  
      DT_EXCLUSAO DATETIME,
      FOREIGN KEY (ACAO) REFERENCES ADM_ACAO_ROBO(ACAO),
      FOREIGN KEY (ID_ROTINA) REFERENCES ADM_ROTINAS(ID_ROTINA)
    );
''';

  String get _insertExemplo => '''
    INSERT INTO ADM_ROTINAS(NOME, ATIVO, EDITAVEL)
    VALUES('TESTE1 DE ROTINA', 'S', 'S'),('TESTE2 DE ROTINA', 'S', 'S'),('TESTE3 DE ROTINA', 'S', 'S');
  ''';

  String get _insertExemplo2 => '''
    INSERT INTO ADM_EXECUCAO_ROTINAS(ID_ROTINA, ACAO, DT_EXECUCAO)
    VALUES(1, 'w', CURRENT_TIMESTAMP),(1, 'w', CURRENT_TIMESTAMP);
  ''';

  static Future<int> createItem(
      String NOME, String ATIVO, String EDITAVEL) async {
    final db = await instance.database;

    final data = {'NOME': NOME, 'ATIVO': ATIVO, 'EDITAVEL': EDITAVEL};
    final id = await db.insert('ADM_ROTINAS', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> deleteItem(int ROTINA) async {
    final db = await instance.database;
    final DT_ATUAL = DateTime.now()
        .copyWith(millisecond: 0, microsecond: 0)
        .toIso8601String();
    final id = await db.transaction((txn) async {
      final countRotinas = await txn.update(
        'ADM_ROTINAS',
        {'DT_EXCLUSAO': DT_ATUAL},
        where: 'ROTINA = ?',
        whereArgs: [ROTINA],
      );
      final countExecucaoRotinas = await txn.update(
        'ADM_EXECUCAO_ROTINAS',
        {'DT_EXCLUSAO': DT_ATUAL},
        where: 'ROTINA = ?',
        whereArgs: [ROTINA],
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
        where: 'DT_EXCLUSAO IS NULL', orderBy: "ROTINA");
  }
}
