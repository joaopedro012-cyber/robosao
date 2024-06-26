//import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class botaoComIcone extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String link;

  const botaoComIcone({
    Key? key,
    required this.color,
    required this.icon,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor): color),
      onPressed: () {
        //lógica para o link
      },
      child: Icon(icon),
    );
  }
}
