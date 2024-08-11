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
    await db.execute(_rotina);
    await db.execute(_execRotina);
    await db.execute(_insertExemplo);
  }

  String get _rotina => '''
    CREATE TABLE ADM_ROTINAS (
      ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
      NOME VARCHAR(200),
      ATIVO CHAR(1) CHECK (ATIVO IN ('S', 'N')),
      EDITAVEL CHAR(1) CHECK (ATIVO IN ('S', 'N')),
      DT_CRIACAO TEXT DEFAULT (CURRENT_TIMESTAMP)
    );
  ''';

  String get _execRotina => '''
    CREATE TABLE ADM_EXECUCAO_ROTINAS (
      EXECUCAO INTEGER PRIMARY KEY AUTOINCREMENT,
      ROTINA INTEGER,
      FOREIGN KEY (ROTINA) REFERENCES ADM_ROTINAS(ROTINA),
      ACAO VARCHAR(100)
      DT_EXECUCAO TEXT DEFAULT (CURRENT_TIMESTAMP)
    );
''';

  String get _insertExemplo => '''
    CREATE TABLE ADM_ROTINAS (
      ROTINA INTEGER PRIMARY KEY AUTOINCREMENT,
      NOME VARCHAR(200),
      ATIVO CHAR(1) CHECK (ATIVO IN ('S', 'N')),
      EDITAVEL CHAR(1) CHECK (ATIVO IN ('S', 'N')),
      DT_CRIACAO TEXT DEFAULT (CURRENT_TIMESTAMP)
    );
  ''';
}
