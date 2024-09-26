import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String? selected;
    const rotinasNoDiretorio = <String>[
      'Abyssinian',
      'Aegean',
      'American Bobtail',
      'American Curl',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: screenWidth * 0.35,
          child: Wrap(
            children: [
              SizedBox(
                width: screenWidth * 0.27,
                children: [
                  fui.AutoSuggestBox<String>(
                    placeholder: 'Rotinas',
                    items: rotinasNoDiretorio.map((cat) {
                      return fui.AutoSuggestBoxItem<String>(
                          value: cat,
                          label: cat,
                          onFocusChange: (focused) {
                            if (focused) {
                              debugPrint('Focused $cat');
                            }
                          });
                    }).toList(),
                    onSelected: (item) {
                      setState(() => selected = item.value);
                    },
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
