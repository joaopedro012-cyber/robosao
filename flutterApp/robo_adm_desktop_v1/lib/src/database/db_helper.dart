import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    const String path = 'C:/Users/joao-/Documents/Github/robo_automacao/flutterApp/robo_adm_desktop_v1/usuarios.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
        await _insertDefaultUsers(db);
      },
    );
  }

  Future<void> _insertDefaultUsers(Database db) async {
    await addUser(db, 'admin', '1234');
    await addUser(db, 'joao', 'joao132');
  }

  Future<void> addUser(Database db, String username, String password) async {
    try {
      await db.insert(
        'usuarios',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.ignore, // Evita erro se usuário já existir
      );
      print('Usuário adicionado: $username');
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
    }
  }

  Future<bool> validateUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password.trim()],
    );
    if (result.isNotEmpty) {
      print('Usuário validado com sucesso!');
      return true;
    } else {
      print('Usuário ou senha incorretos.');
      return false;
    }
  }

  Future<void> initDatabase() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('usuarios');
    if (users.isEmpty) {
      print('Nenhum usuário encontrado. Criando usuários padrão...');
      await _insertDefaultUsers(db);
    } else {
      print('Usuários já cadastrados: $users');
    }
  }
}
