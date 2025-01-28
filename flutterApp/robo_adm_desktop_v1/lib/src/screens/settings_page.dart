import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'daltonismo_inherited_widget.dart'; // Importando o arquivo do InheritedWidget

class ConfiguracoesPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ConfiguracoesPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  ConfiguracoesPageState createState() => ConfiguracoesPageState();
}

class ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late bool isDarkMode;
  late String screenMode;
  bool isDaltonismo = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    screenMode = 'Janela'; // Definindo o valor padrão
    _loadSettings();
  }

  // Carrega as configurações salvas
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? widget.isDarkMode;
      screenMode = prefs.getString('screenMode') ?? 'Janela';
      isDaltonismo = prefs.getBool('isDaltonismo') ?? false; // Carregando a configuração do Daltonismo
    });
  }

  // Salva as configurações
  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setString('screenMode', screenMode);
    prefs.setBool('isDaltonismo', isDaltonismo); // Salvando configuração de Daltonismo
    widget.onThemeChanged(isDarkMode); // Atualiza o tema global
  }

  @override
  Widget build(BuildContext context) {
    // Usando o InheritedWidget para passar o estado do Daltonismo para as telas
    return DaltonismoInheritedWidget(
      isDaltonismo: isDaltonismo,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          title: const Text('Configurações', style: TextStyle(color: Colors.blueAccent)),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.blueAccent),
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Tema'),
              _buildSwitchTile(
                title: isDarkMode ? 'Modo Escuro' : 'Modo Claro',
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  _saveSettings();
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Modo de Exibição'),
              _buildDropdownButton(),
              const SizedBox(height: 20),
              _buildSectionTitle('Modo Daltonismo'),
              _buildSwitchTile(
                title: 'Ativar Modo Daltonismo',
                value: isDaltonismo,
                onChanged: (value) {
                  setState(() {
                    isDaltonismo = value;
                  });
                  _saveSettings();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.blueAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      child: SwitchListTile(
        title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.blueAccent)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
        activeTrackColor: Colors.blue,
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      child: DropdownButton<String>(
        value: screenMode,
        items: <String>['Tela cheia', 'Janela', 'Janela com tela cheia']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.blueAccent)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            screenMode = value!;
          });
          _saveSettings();
        },
        dropdownColor: isDarkMode ? Colors.black : Colors.white,
        iconEnabledColor: isDarkMode ? Colors.white : Colors.blueAccent,
      ),
    );
  }
}
