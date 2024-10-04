import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;

class AutomacaoCampo extends StatelessWidget {
  final String campo;
  final String placeholder;
  final List<fui.AutoSuggestBoxItem<String>> portasArduino;
  final Function(String) onPortasChanged;

  const AutomacaoCampo({
    super.key,
    required this.campo,
    required this.placeholder,
    required this.portasArduino,
    required this.onPortasChanged,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Wrap(
      children: [
        Text(campo),
        SizedBox(
          width: screenWidth * 0.35,
          child: Wrap(
            children: [
              SizedBox(
                width: screenWidth * 0.27,
                child: fui.AutoSuggestBox<String>(
                  placeholder: placeholder,
                  items: portasArduino.map((arduino) {
                    return fui.AutoSuggestBoxItem<String>(
                      value: arduino,
                      label: arduino,
                      onFocusChange: (focused) {
                        if (focused) {
                          debugPrint('Focused $arduino');
                        }
                      },
                    );
                  }).toList(),
                  onSelected: (item) {
                    onPortasChanged(item.value!);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
