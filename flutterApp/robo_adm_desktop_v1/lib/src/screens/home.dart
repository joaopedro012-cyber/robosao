import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/screens/rotinas.dart';



class HomePage extends StatefulWidget { // Renomeado de NavigationView para HomePage
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int topIndex = 0;
  PaneDisplayMode displayMode = PaneDisplayMode.auto;

  List<NavigationPaneItem> items = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Inicio'),
      body: const Center(child: Text('Inicio')),
    ),
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.robot),
      title: const Text('Automação'),
      body: const Center(
        child: Text('Automação'),
      ),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.compass_n_w),
      title: const Text('GPS'),
      body: const Center(child: Text('GPS')),
      enabled: true,
    ),PaneItem(
          icon: const Icon(FluentIcons.power_button),
          title: const Text('Inicialização'),
          body: const Center(child: Text('Inicialização')),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.log_remove),
          title: const Text('Log'),
          body: const Center(child: Text('Log')),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.mobile_selected),
          title: const Text('Mobile'),
          body: const Center(child: Text('Mobile')),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.clipboard_list),
          title: const Text('Rotinas'),
          body: const RotinasPage(),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.communications),
          title: const Text('Sensores'),
          body: const Center(child: Text('Sensores')),
        ),
        PaneItem(
          icon: const Icon(FluentIcons.check_list),
          title: const Text('Status'),
          body: const Center(child: Text('Status')),
        ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationView( // Use o widget NavigationView do Fluent UI aqui
        appBar: const NavigationAppBar(
          title: Text('Robo Administrativo Desktop'),
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
