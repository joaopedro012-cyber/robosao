import 'package:flutter/material.dart';
import 'package:robo_adm_desktop_v1/src/utils/json_config.dart';

class AutomacaoCampo extends StatefulWidget {
  final String objetoAutomacao;

  const AutomacaoCampo({super.key, required this.objetoAutomacao});

  @override
  AutomacaoCampoState createState() => AutomacaoCampoState();
}

class AutomacaoCampoState extends State<AutomacaoCampo> {
  TextEditingController controller = TextEditingController();
  bool _isLoading = false; // Flag para controle de carregamento

  @override
  void initState() {
    super.initState();
    _carregarValor();
  }

  // Carregar valor do objeto de automação do config.json
  Future<void> _carregarValor() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    dynamic valor =
        await carregaInfoJson('automacao', widget.objetoAutomacao, 'valor');
    if (valor != null) {
      controller.text = valor.toString();
    } else {
      controller.text =
          ''; // Caso o valor seja nulo, deixamos o campo em branco
    }

    if (mounted) {
      // Verifica se o widget ainda está montado
      setState(() {
        _isLoading = false; // Finaliza o carregamento
      });
    }
  }

  // Atualizar o valor do objeto de automação no config.json
  Future<void> _atualizarValor() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento ao salvar os dados
    });

    await atualizaJson(
        'automacao', widget.objetoAutomacao, 'valor', controller.text);

    if (mounted) {
      // Verifica se o widget ainda está montado
      setState(() {
        _isLoading = false; // Finaliza o carregamento
      });

      // Feedback visual quando o valor for atualizado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.objetoAutomacao,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          // Campo de texto com feedback de carregamento
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Valor',
              border: const OutlineInputBorder(),
              suffixIcon: _isLoading
                  ? const CircularProgressIndicator()
                  : null, // Ícone de carregamento quando o valor está sendo atualizado
            ),
            onChanged: (_) {
              _atualizarValor(); // Atualiza o valor no config.json assim que o campo for alterado
            },
          ),
        ],
      ),
    );
  }
}
