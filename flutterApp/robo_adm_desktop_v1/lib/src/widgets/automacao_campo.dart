import 'package:flutter/material.dart'; 
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';
import 'package:libserialport/libserialport.dart';

class AutomacaoCampo extends StatefulWidget {
  final String objetoAutomacao;
  const AutomacaoCampo({super.key, required this.objetoAutomacao});

  @override
  State<AutomacaoCampo> createState() => _AutomacaoCampoState();
}

class _AutomacaoCampoState extends State<AutomacaoCampo> {
  fui.AutoSuggestBoxItem<String>? selected;
  String? porta = 'Porta não encontrada'; // Aceita nulo agora
  List<fui.AutoSuggestBoxItem<String>> objetoListaDePortas = [];
  bool isConnected = false;
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    _carregaPortasDisponiveis();
    carregaInfo();
  }

  /// Carrega a lista de portas seriais disponíveis e preenche o campo de sugestão.
  void _carregaPortasDisponiveis() {
    try {
      objetoListaDePortas = SerialPort.availablePorts
          .map((port) => fui.AutoSuggestBoxItem<String>(value: port, label: port))
          .toList();
    } catch (e) {
      print('Erro ao carregar portas: $e');
    }
  }

  /// Carrega informações da porta a partir do arquivo JSON de configuração.
  Future<void> carregaInfo() async {
    try {
      String? portaCarregada = await carregaInfoJson('automacao', widget.objetoAutomacao, 'porta');
      setState(() {
        porta = portaCarregada ?? 'Porta não encontrada';
        isConnected = portaCarregada != null;
      });
    } catch (e) {
      print('Erro ao carregar informações da porta: $e');
    }
  }

  /// Atualiza o status de conexão da porta selecionada no JSON.
  Future<void> _atualizaPortaSelecionada(fui.AutoSuggestBoxItem<String> item) async {
    setState(() => selected = item);
    try {
      await atualizaJson('automacao', widget.objetoAutomacao, 'porta', item.value);
      setState(() {
        porta = item.value;
        isConnected = true;
      });
    } catch (e) {
      print('Erro ao atualizar a porta no JSON: $e');
    }
  }

  /// Atualiza a lista de portas disponíveis.
  void _atualizarPortas() {
    setState(() => _carregaPortasDisponiveis());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      spacing: screenWidth * 0.05,
      runSpacing: screenWidth * 0.02,
      children: [
        SizedBox(
          width: screenWidth * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.objetoAutomacao),
              SizedBox(
                width: screenWidth * 0.30,
                child: fui.AutoSuggestBox<String>(
                  placeholder: porta ?? 'Porta não encontrada',
                  items: objetoListaDePortas,
                  onSelected: _atualizaPortaSelecionada,
                ),
              ),
              Row(
                children: [
                  fui.Tooltip(
                    message: 'Atualizar portas',
                    child: fui.IconButton(
                      icon: const Icon(fui.FluentIcons.refresh),
                      onPressed: _atualizarPortas,
                    ),
                  ),
                  Text(
                    isConnected ? 'Conectado' : 'Desconectado',
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
