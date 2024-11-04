import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/screens/automacao.dart';
import 'package:robo_adm_desktop_v1/src/screens/rotinas.dart';
import 'package:robo_adm_desktop_v1/src/screens/sensores.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int topIndex = 0;
  PaneDisplayMode displayMode = PaneDisplayMode.auto;

  // Função para gerar a lista de itens de navegação
  List<NavigationPaneItem> _getNavigationItems() {
    return [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Inicio'),
        body: const Center(child: Text('Inicio')),
      ),
      PaneItemSeparator(),
      PaneItem(
        icon: const Icon(FluentIcons.robot),
        title: const Text('Automação'),
        body: const Center(child: AutomacaoPage()),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.compass_n_w),
        title: const Text('GPS'),
        body: const Center(child: Text('GPS')),
      ),
      PaneItem(
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
        body: const SensoresPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.waitlist_confirm),
        title: const Text('Status'),
        body: const Center(child: Text('Status')),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationView(
        appBar: const NavigationAppBar(
          automaticallyImplyLeading: false,
          title: Text('Robo Administrativo Desktop'),
        ),
        pane: NavigationPane(
          selected: topIndex,
          displayMode: displayMode,
          onChanged: (index) => setState(() => topIndex = index),
          items: _getNavigationItems(),
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Configurações'),
              body: const Center(child: Text('Página de Configurações')),
            ),
          ],
        ),
      ),
    );
  }
}
