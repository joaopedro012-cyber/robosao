import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/screens/automacao.dart';
import 'package:robo_adm_desktop_v1/src/screens/rotinas.dart';
import 'package:robo_adm_desktop_v1/src/screens/sensores.dart';
import 'package:robo_adm_desktop_v1/src/screens/gps_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/log_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/status_module.dart';
import 'package:robo_adm_desktop_v1/src/screens/settings_page.dart';
import 'package:robo_adm_desktop_v1/src/screens/login.dart'; // A tela de login

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
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Início'),
        body: const Center(child: Text('Início')), // Adicionei o corpo do item
      ),
      PaneItemSeparator(),
      PaneItem(
        icon: const Icon(FluentIcons.robot),
        title: const Text('Automação'),
        body: const AutomacaoPage(), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.compass_n_w),
        title: const Text('GPS'),
        body: const GPSModuleWidget(), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.power_button),
        title: const Text('Inicialização'),
        body: const Center(child: Text('Inicialização')), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.log_remove),
        title: const Text('Log'),
        body: const LogPage(), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.mobile_selected),
        title: const Text('Mobile'),
        body: const Center(child: Text('Mobile')), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.clipboard_list),
        title: const Text('Rotinas'),
        body: RotinasPage(
          conexaoAtiva: true, // Parâmetro de conexão
          onPause: () {
            print('Rotina pausada');
          },
          onResume: () {
            print('Rotina retomada');
          },
        ), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.communications),
        title: const Text('Sensores'),
        body: const ControlePage(), // Adicionei o corpo do item
      ),
      PaneItem(
        icon: const Icon(FluentIcons.waitlist_confirm),
        title: const Text('Status'),
        body: const StatusPage(), // Adicionei o corpo do item
      ),
      // Item de navegação para Configurações
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('Configurações'),
        body: const Center(child: Text('Página de Configurações')), // Adicionei o corpo do item
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfiguracoesPage(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: widget.onThemeChanged ?? (value) {}, // Passa a função ou null
              ),
            ),
          );
        },
      ),
      // Item de navegação para "Sair"
      PaneItem(
        icon: const Icon(FluentIcons.sign_out),
        title: const Text('Sair'),
        body: const SizedBox.shrink(),  // Adiciona um corpo vazio
        onTap: () {
          _logout();
        },
      ),
    ];
  }

  // Função para logout e navegação para o menu de login
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
    );
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
