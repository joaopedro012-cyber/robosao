import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:path_provider/path_provider.dart';
import 'package:robo_adm_desktop_v1/src/screens/home.dart';
import 'package:window_manager/window_manager.dart';

Future<void> criarPastaDeRotinas() async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String novoCaminho = '${documentsDirectory.path}/Rotinas Robo';
  final Directory novoDiretorio = Directory(novoCaminho);

  if (!await novoDiretorio.exists()) {
    await novoDiretorio.create(recursive: true);
  }

  final File configFile = File('${novoDiretorio.path}/config.json');
  if (!await configFile.exists()) {
    await configFile.writeAsString('''
{
  "sensores": [
    {
      "sensor": "sensor1",
      "diretorio": "caminho/para/sensor1",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor2",
      "diretorio": "caminho/para/sensor2",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor3",
      "diretorio": "caminho/para/sensor3",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor4",
      "diretorio": "caminho/para/sensor4",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor5",
      "diretorio": "caminho/para/sensor5",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor6",
      "diretorio": "caminho/para/sensor6",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor7",
      "diretorio": "caminho/para/sensor7",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor8",
      "diretorio": "caminho/para/sensor8",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor9",
      "diretorio": "caminho/para/sensor9",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor10",
      "diretorio": "caminho/para/sensor10",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor11",
      "diretorio": "caminho/para/sensor11",
      "distancia_minima": 10
    },
    {
      "sensor": "sensor12",
      "diretorio": "caminho/para/sensor12",
      "distancia_minima": 10
    }
  ]
}

''');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  await criarPastaDeRotinas();
  windowManager.waitUntilReadyToShow().then(
    (_) async {
      await windowManager.setMinimumSize(const Size(657, 300));
      await windowManager.show();
      await windowManager.setPreventClose(false);
      await windowManager.setSkipTaskbar(false);
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Navegação',
      theme: FluentThemeData(),
      home: const HomePage(),
    );
  }
}
