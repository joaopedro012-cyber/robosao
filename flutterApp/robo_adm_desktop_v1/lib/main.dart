import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:robo_adm_desktop_v1/src/screens/home.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
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
      home: const HomePage(), // Use o novo nome da classe aqui
    );
  }
}

