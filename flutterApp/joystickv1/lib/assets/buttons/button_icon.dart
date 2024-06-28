//import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class botaoComIcone extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const botaoComIcone({
    Key? key,
    required this.color,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
