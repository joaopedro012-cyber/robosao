import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/screens/automacao.dart';
import 'package:robo_adm_desktop_v1/src/screens/rotinas.dart';
import 'package:robo_adm_desktop_v1/src/screens/sensores.dart';
import 'package:robo_adm_desktop_v1/src/screens/gps_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/log_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/status_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/settings_page.dart';
import 'package:robo_adm_desktop_v1/src/screens/login.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode; // Modo escuro
  final ValueChanged<bool>? onThemeChanged; // Tornar opcional

  const HomePage({super.key, required this.isDarkMode, this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int topIndex = 0;
  PaneDisplayMode displayMode = PaneDisplayMode.auto;

  // Função para gerar a lista de itens de navegação
  List<NavigationPaneItem> _getNavigationItems() {
    return [
      // Página Inicial
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Início'),
        body: const Center(child: Text('Início')),
      ),
      PaneItemSeparator(),

      // Página de Automação
      PaneItem(
        icon: const Icon(FluentIcons.robot),
        title: const Text('Automação'),
        body: const AutomacaoPage(),
      ),

      // Página de GPS
      PaneItem(
        icon: const Icon(FluentIcons.compass_n_w),
        title: const Text('GPS'),
        body: const GPSModuleWidget(),
      ),

      // Página de Inicialização
      PaneItem(
        icon: const Icon(FluentIcons.power_button),
        title: const Text('Inicialização'),
        body: const Center(child: Text('Inicialização')),
      ),

      // Página de Log
      PaneItem(
        icon: const Icon(FluentIcons.log_remove),
        title: const Text('Log'),
        body: const LogPage(),
      ),

      // Página Mobile
      PaneItem(
        icon: const Icon(FluentIcons.mobile_selected),
        title: const Text('Mobile'),
        body: const Center(child: Text('Mobile')),
      ),

      // Página de Rotinas
      PaneItem(
        icon: const Icon(FluentIcons.clipboard_list),
        title: const Text('Rotinas'),
        body: RotinasPage(
          conexaoAtiva: true,
          onPause: () {
            print('Rotina pausada');
          },
          onResume: () {
            print('Rotina retomada');
          },
        ),
      ),

      // Página de Sensores
      PaneItem(
        icon: const Icon(FluentIcons.communications),
        title: const Text('Sensores'),
        body: const ControlePage(),
      ),

      // Página de Status
      PaneItem(
        icon: const Icon(FluentIcons.waitlist_confirm),
        title: const Text('Status'),
        body: const StatusPage(),
      ),

      // Página de Configurações
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('Configurações'),
        body: const Center(child: Text('Página de Configurações')),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfiguracoesPage(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: widget.onThemeChanged ?? (value) {},
              ),
            ),
          );
        },
      ),
      PaneItemSeparator(),

      // Página de Sair
      PaneItem(
        icon: const Icon(FluentIcons.sign_out),
        title: const Text('Sair'),
        body: const Center(child: Text('Saindo...')), // Adicionando um corpo obrigatório
        onTap: () {
          Navigator.pushReplacement(
            context,
            FluentPageRoute(builder: (context) => const LoginPage()),
          );
        },
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
          onChanged: (index) => setState(() {
            topIndex = index;
          }),
          items: _getNavigationItems(),
        ),
      ),
    );
  }
}
