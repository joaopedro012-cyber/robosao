import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/screens/automacao.dart';
import 'package:robo_adm_desktop_v1/src/screens/rotinas.dart';
import 'package:robo_adm_desktop_v1/src/screens/sensores.dart'; // Importando a tela de Bluetooth
import 'package:robo_adm_desktop_v1/src/screens/gps_module.dart'; // Importando a tela de GPS
import 'package:robo_adm_desktop_v1/src/screens/log_module.dart'; // Tela de Log
import 'package:robo_adm_desktop_v1/src/screens/status_module.dart'; // Tela de Status
import 'package:robo_adm_desktop_v1/src/screens/settings_page.dart'; // Importando a tela de configurações

class HomePage extends StatefulWidget {
  final bool isDarkMode; // Recebe a variável de modo escuro
  final ValueChanged<bool> onThemeChanged; // Função para alterar o tema

  const HomePage({super.key, required this.isDarkMode, required this.onThemeChanged});

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
        body: const Center(child: AutomacaoPage()), // Página de Automação
      ),
      PaneItem(
        icon: const Icon(FluentIcons.compass_n_w),
        title: const Text('GPS'),
        body: const Center(child: GPSModuleWidget()), // Página de GPS
      ),
      PaneItem(
        icon: const Icon(FluentIcons.power_button),
        title: const Text('Inicialização'),
        body: const Center(child: Text('Inicialização')), // Página de Inicialização
      ),
      PaneItem(
        icon: const Icon(FluentIcons.log_remove),
        title: const Text('Log'),
        body: const LogPage(), // Página de Log
      ),
      PaneItem(
        icon: const Icon(FluentIcons.mobile_selected),
        title: const Text('Mobile'),
        body: const Center(child: Text('Mobile')), // Página de Mobile
      ),
      PaneItem(
        icon: const Icon(FluentIcons.clipboard_list),
        title: const Text('Rotinas'),
        body: RotinasPage(
          conexaoAtiva: true, // Passando o parâmetro de conexão
          onPause: () {
            // Função que será chamada para pausar a execução da rotina
            print('Rotina pausada');
          },
          onResume: () {
            // Função que será chamada para retomar a execução da rotina
            print('Rotina retomada');
          },
        ), // Passando os parâmetros onPause e onResume
      ),
      PaneItem(
        icon: const Icon(FluentIcons.communications),
        title: const Text('Sensores'),
        body: const SensoresPage(), // Página de Sensores
      ),
      PaneItem(
        icon: const Icon(FluentIcons.waitlist_confirm),
        title: const Text('Status'),
        body: const StatusPage(), // Página de Status
      ),
      // Item de navegação para as configurações
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('Configurações'),
        body: const Center(child: Text('Página de Configurações')),
        onTap: () {
          // Ao clicar em Configurações, navega para a tela de configurações
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfiguracoesPage(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: widget.onThemeChanged,
              ),
            ),
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
          onChanged: (index) => setState(() => topIndex = index),
          items: _getNavigationItems(),
        ),
      ),
    );
  }
}
