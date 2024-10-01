import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;

class SensorRotina extends StatelessWidget {
  final String sensor;
  final String placeholder;
  final List<String> rotinas;
  final int? distanciaMinima;
  final Function(int?) onDistanciaChanged;
  final Function(String) onDiretorioChanged;

  const SensorRotina({
    super.key,
    required this.sensor,
    required this.placeholder,
    required this.rotinas,
    this.distanciaMinima,
    required this.onDistanciaChanged,
    required this.onDiretorioChanged,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int? numberBoxValue = distanciaMinima;

    return Wrap(
      children: [
        Text(sensor),
        SizedBox(
          width: screenWidth * 0.35,
          child: Wrap(
            children: [
              SizedBox(
                width: screenWidth * 0.27,
                child: fui.AutoSuggestBox<String>(
                  placeholder: placeholder,
                  items: rotinas.map((rotina) {
                    return fui.AutoSuggestBoxItem<String>(
                      value: rotina,
                      label: rotina,
                      onFocusChange: (focused) {
                        if (focused) {
                          debugPrint('Focused $rotina');
                        }
                      },
                    );
                  }).toList(),
                  onSelected: (item) {
                    onDiretorioChanged(item.value!);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.25,
          child: fui.NumberBox(
            value: numberBoxValue,
            onChanged: (novoValor) {
              onDistanciaChanged(novoValor);
            },
            mode: fui.SpinButtonPlacementMode.inline,
          ),
        ),
        const Text('cm'),
      ],
    );
  }
}
