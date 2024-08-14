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
    await db.execute(_createTempRotina);
    await db.execute(_insertExemplo);
  }

  String get _createAcaoRobo => '''
    CREATE TABLE ADM_ACAO_ROBO (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      ACAO VARCHAR(100),
      NOME VARCHAR(200)
    );
''';

  String get _insereAcoesIniciais => '''
    INSERT INTO ADM_ACAO_ROBO (ACAO, NOME)
    VALUES('w','Frente'),('x','Trás'),('a','Esquerda'),('d','Direita');
''';

  String get _createRotina => '''
    CREATE TABLE ADM_ROTINAS (
      ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
      NOME VARCHAR(200) NOT NULL,
      ATIVO CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      EDITAVEL CHAR(1) NOT NULL CHECK (ATIVO IN ('S', 'N')),
      DT_CRIACAO TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP)
    );
  ''';

  String get _createExecRotina => '''
    CREATE TABLE ADM_EXECUCAO_ROTINAS (
      EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ROTINA INTEGER NOT NULL,
      DT_INI TEXT NOT NULL,  
      DT_FIM TEXT NOT NULL,
      FOREIGN KEY (ACAO) REFERENCES ADM_ACAO_ROBO,
      FOREIGN KEY (ROTINA) REFERENCES ADM_ROTINAS(ROTINA)
    );
''';

  String get _createTempRotina => '''
    CREATE TABLE ADM_TEMP_EXECUCAO_ROTINAS (
      EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ROTINA INTEGER,
      DT_EXECUCAO TEXT DEFAULT (CURRENT_TIMESTAMP),
      FOREIGN KEY (ACAO) REFERENCES ADM_ACAO_ROBO,
      FOREIGN KEY (ROTINA) REFERENCES ADM_ROTINAS(ROTINA)
    );
''';

  String get _insertExemplo => '''
    INSERT INTO ADM_ROTINAS(NOME, ATIVO, EDITAVEL)
    VALUES( 'TESTE DE ROTINA', 'S', 'S');
  ''';

  Future<List<Map<String, dynamic>>> getRotinas() async {
    final db = await instance.database;
    return await db.query('ADM_ROTINAS');
  }
}
