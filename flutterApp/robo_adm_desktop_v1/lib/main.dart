import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:path_provider/path_provider.dart';
import 'package:robo_adm_desktop_v1/src/screens/home.dart';
import 'package:robo_adm_desktop_v1/src/widgets/cria_config_json.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> criarPastaDeRotinas() async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String novoCaminho = '${documentsDirectory.path}/Rotinas Robo';
  final Directory novoDiretorio = Directory(novoCaminho);

  if (!await novoDiretorio.exists()) {
    await novoDiretorio.create(recursive: true);
  }

  final File configFile = File('${novoDiretorio.path}/config.json');
  if (!await configFile.exists()) {
    CriadorConfig(); // Criação da configuração inicial, sem necessidade de comentários
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  await criarPastaDeRotinas();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(657, 300));
    await windowManager.show();
    await windowManager.setPreventClose(false);
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Controlador de tema
  String screenMode = 'Janela'; // Controlador do modo da tela

  // Função para salvar as configurações (tema e tamanho da tela)
  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setString('screenMode', screenMode);

    // Altera o tamanho da janela dependendo do modo de exibição
    if (screenMode == 'Tela cheia') {
      await windowManager.setFullScreen(true); // Tela cheia
    } else {
      await windowManager.setFullScreen(false); // Desativa a tela cheia
      if (screenMode == 'Janela') {
        // Tamanho personalizado da janela
        await windowManager.setSize(const Size(1960, 800));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Robo Administrativo Desktop',
      theme: isDarkMode ? FluentThemeData.dark() : FluentThemeData.light(),
      home: HomePage(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
          _saveSettings();
        },
      ),
    );
  }
}
