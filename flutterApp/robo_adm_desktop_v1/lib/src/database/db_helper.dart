import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login SQLite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // Capture o BuildContext imediatamente
    final BuildContext ctx = context as BuildContext;
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    // Verifica se os campos foram preenchidos
    if (username.isEmpty || password.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Preencha os campos!')),
        );
      });
      return;
    }

    // Validação do usuário
    final bool isValid =
        await DatabaseHelper.instance.validateUser(username, password);

    if (!mounted) return;

    // Agendar a exibição do SnackBar para o próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isValid) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );
        // Aqui você pode navegar para outra tela, se desejar
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha incorretos!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final String path = join(await getDatabasesPath(), 'usuarios.db');
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
      },
    );
  }
  
  Future<void> initDatabase() async {
    await database;
    // Usando ConflictAlgorithm.replace para atualizar ou inserir os usuários padrão
    await addUser('admin', '1234');
    await addUser('joao', '456456'); // Cria ou atualiza o usuário "joao"
  }
  
  Future<void> addUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'usuarios',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<bool> validateUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }
}
