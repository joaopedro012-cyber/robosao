import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:robo_adm_desktop_v1/src/database/db_helper.dart';
import 'package:robo_adm_desktop_v1/src/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Erro'),
          content: const Text('Preencha os campos!'),
          severity: InfoBarSeverity.warning,
          onClose: close,
        ),
      );
      return;
    }

    final bool isValid = await DatabaseHelper.instance.validateUser(username, password);

    if (!mounted) return;

    if (isValid) {
      displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Sucesso'),
          content: const Text('Login bem-sucedido!'),
          severity: InfoBarSeverity.success,
          onClose: close,
        ),
      );

      Navigator.pushReplacement(
        context,
        FluentPageRoute(
          builder: (context) => const HomePage(isDarkMode: false),
        ),
      );
    } else {
      displayInfoBar(
        context,
        builder: (context, close) => InfoBar(
          title: const Text('Erro'),
          content: const Text('Usuário ou senha incorretos!'),
          severity: InfoBarSeverity.error,
          onClose: close,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_animationController.value),
                child: Container(),
              );
            },
          ),
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A00E0),
                    Color(0xFF8E2DE2),
                  ],
                  stops: [0.2, 0.8],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Acesso Futurista',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                    controller: _usernameController,
                    placeholder: 'Usuário',
                  ),
                  const SizedBox(height: 10),
                  TextBox(
                    controller: _passwordController,
                    placeholder: 'Senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;
  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues()
      ..style = PaintingStyle.fill;
    final random = Random();

    for (int i = 0; i < 100; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = (random.nextDouble() * size.height) + (animationValue * 100);
      canvas.drawCircle(Offset(dx, dy % size.height), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
