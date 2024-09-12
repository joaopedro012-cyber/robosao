import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then(
    (_) async {
      await windowManager.setMinimumSize(const Size(200, 300));
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
      home: const MyNavigationView(), // Use o novo nome da classe aqui
    );
  }
}

class MyNavigationView extends StatefulWidget { // Renomeado de NavigationView para MyNavigationView
  const MyNavigationView({super.key});

  @override
  State<MyNavigationView> createState() => _MyNavigationViewState();
}

class _MyNavigationViewState extends State<MyNavigationView> {
  int topIndex = 0;
  PaneDisplayMode displayMode = PaneDisplayMode.compact;

  List<NavigationPaneItem> items = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Inicio'),
      body: const Center(child: Text('Inicio')),
    ),
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.issue_tracking),
      title: const Text('Track Orders'),
      infoBadge: const InfoBadge(source: Text('8')),
      body: const Center(
        child: Text('Order tracking information here.'),
      ),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.disable_updates),
      title: const Text('Disabled Item'),
      body: const Center(child: Text('This item is disabled')),
      enabled: false,
    ),
    PaneItemExpander(
      icon: const Icon(FluentIcons.account_management),
      title: const Text('Account'),
      body: const Center(child: Text('Account Information')),
      items: [
        PaneItem(
          icon: const Icon(FluentIcons.mail),
          title: const Text('Mail'),
          body: const Center(child: Text('Mail Page')),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.calendar),
          title: const Text('Calendar'),
          body: const Center(child: Text('Calendar Page')),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationView( // Use o widget NavigationView do Fluent UI aqui
        appBar: const NavigationAppBar(
          title: Text('NavigationView Example'),
        ),
        pane: NavigationPane(
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          displayMode: displayMode,
          items: items,
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
              body: const Center(child: Text('Settings Page')),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.add),
              title: const Text('Add New Item'),
              onTap: () {
                // Lógica para adicionar novo item
                items.add(
                  PaneItem(
                    icon: const Icon(FluentIcons.new_folder),
                    title: const Text('New Item'),
                    body:
                        const Center(child: Text('This is a newly added item')),
                  ),
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
