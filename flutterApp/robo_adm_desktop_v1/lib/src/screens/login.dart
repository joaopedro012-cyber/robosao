import 'package:fluent_ui/fluent_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:robo_adm_desktop_v1/src/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  Future<bool> _validarLogin(String usuario, String senha) async {
    return await DatabaseHelper.instance.validateUser(usuario, senha);
  }

  void _login(BuildContext context) async {
    // Antes de fazer qualquer operação assíncrona, verificamos se o widget está montado
    if (!mounted) return;

    bool credenciaisValidas = await _validarLogin(_userController.text, _passwordController.text);

    // Verificando se o widget ainda está montado antes de atualizar o estado
    if (!mounted) return;

    if (credenciaisValidas) {
      // Após verificar se o widget está montado, podemos realizar a navegação
      if (!mounted) return;

      // Navegação para a página Home
      if (context.mounted) {  // Verifique se o contexto ainda está montado
        Navigator.pushReplacement(
          context,
          FluentPageRoute(
            builder: (BuildContext context) => const HomePage(isDarkMode: false, onThemeChanged: null),
          ),
        );
      }
    } else {
      // Atualizando a UI caso as credenciais sejam inválidas
      if (!mounted) return;
      setState(() {
        errorMessage = 'Usuário ou senha incorretos!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Card(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextBox(controller: _userController, placeholder: 'Usuário'),
                const SizedBox(height: 10),
                TextBox(controller: _passwordController, placeholder: 'Senha', obscureText: true),
                const SizedBox(height: 10),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                FilledButton(onPressed: () => _login(context), child: const Text('Entrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Banco de Dados SQLite para armazenar os usuários
// ==========================================================
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
    final path = join(await getDatabasesPath(), 'usuarios.db');
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

        // Adicionar usuário inicial, caso não exista
        await db.insert(
          'usuarios',
          {'username': 'admin', 'password': '1234'},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      },
    );
  }

  Future<void> initDatabase() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('usuarios');

    // Se o banco estiver vazio, adiciona um usuário padrão
    if (users.isEmpty) {
      await addUser('admin', '1234');
      print("Usuário admin criado com sucesso!");
    }
  }

  Future<void> addUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'usuarios',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.ignore,
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
