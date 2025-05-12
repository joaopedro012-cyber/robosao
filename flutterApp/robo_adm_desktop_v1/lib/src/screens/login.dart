import 'package:fluent_ui/fluent_ui.dart';  // Importando Fluent UI para a interface
import 'package:robo_adm_desktop_v1/src/database/db_helper.dart';  // Importando o helper do banco de dados para validação de usuário
import 'package:robo_adm_desktop_v1/src/screens/home.dart';  // Importando a tela inicial do aplicativo

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});  // Construtor da página de login

  @override
  State<LoginPage> createState() => _LoginPageState();  // Criação do estado da página
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  // Controladores para os campos de entrada do usuário e senha
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Controlador de animação para o efeito pulsante no fundo
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializando o controlador de animação com duração de 3 segundos
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);  // Faz a animação repetir com efeito reverso
  }

  @override
  void dispose() {
    _controller.dispose();  // Liberando recursos do controlador de animação
    super.dispose();
  }

  // Função para realizar o login após validação do usuário e senha
  Future<void> _login() async {
    // Obtendo os valores dos campos de usuário e senha
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    // Verificando se os campos de usuário ou senha estão vazios
    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      // Exibe um erro caso os campos estejam vazios
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

    // Validando o usuário e a senha no banco de dados
    final bool isValid = await DatabaseHelper.instance.validateUser(username, password);

    if (!mounted) return;

    // Se o login for bem-sucedido, navega para a página inicial
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

      // Navega para a HomePage após login
      Navigator.pushReplacement(
        context,
        FluentPageRoute(
          builder: (context) => const HomePage(isDarkMode: false),
        ),
      );
    } else {
      // Se o login falhar, exibe uma mensagem de erro
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
          // Animação pulsante no fundo, com base no controlador
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,  // O tamanho do canvas será o tamanho da tela
                painter: PulsatingLinesPainter(_controller.value),  // Chamando o painter com o valor da animação
              );
            },
          ),
          // Container principal com os campos de login
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Gradiente para o fundo do container
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A00E0), // Roxo escuro
                    Color(0xFF8E2DE2), // Roxo claro
                  ],
                  stops: [0.2, 0.8],
                ),
                borderRadius: BorderRadius.circular(12),  // Bordas arredondadas para o container
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(),  // Sombra azul com opacidade
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título da tela de login
                  const Text(
                    'Acesso ROBO',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Campo para inserir o nome de usuário
                  TextBox(
                    controller: _usernameController,
                    placeholder: 'Usuário',
                  ),
                  const SizedBox(height: 10),
                  // Campo para inserir a senha
                  TextBox(
                    controller: _passwordController,
                    placeholder: 'Senha',
                    obscureText: true,  // Oculta o texto da senha
                  ),
                  const SizedBox(height: 20),
                  // Botão para submeter o login
                  FilledButton(
                    onPressed: _login,  // Chama a função de login quando pressionado
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

// Classe para desenhar as linhas pulsantes no fundo da tela
class PulsatingLinesPainter extends CustomPainter {
  final double animationValue;  // Valor da animação para controlar o efeito pulsante

  PulsatingLinesPainter(this.animationValue);  // Construtor recebendo o valor da animação

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues()  // Cor das linhas pulsantes com opacidade
      ..strokeWidth = 2  // Espessura da linha
      ..style = PaintingStyle.stroke;  // Apenas desenha as linhas (sem preenchimento)

    // Desenhando várias linhas horizontais
    for (double i = 0; i < size.height; i += 50) {
      double offset = (animationValue * 20) - 10;  // Movimento da linha com base na animação
      canvas.drawLine(
        Offset(0, i + offset),  // Posição inicial da linha
        Offset(size.width, i + offset),  // Posição final da linha
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;  // Indica que deve repintar constantemente
}
