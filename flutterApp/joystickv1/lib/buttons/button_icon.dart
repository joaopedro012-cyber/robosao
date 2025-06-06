import 'package:flutter/material.dart';

class BotaoComIcone extends StatefulWidget {
  final IconData icone;
  final String textoIcone;
  final Color corDeFundo;
  final VoidCallback onPressed;

  const BotaoComIcone({
    super.key,
    required this.icone,
    required this.textoIcone,
    required this.corDeFundo,
    required this.onPressed,
  });

  @override
  State<BotaoComIcone> createState() => _BotaoComIconeState();
}

class _BotaoComIconeState extends State<BotaoComIcone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      width: 150,
      height: 150,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: widget.corDeFundo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.onPressed,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icone,
              size: 55,
            ),
            const SizedBox(height: 8), // Adicionando espaçamento
            Text(
              widget.textoIcone.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        label: const Text(''), // Você pode colocar um texto aqui se quiser
      ),
    );
  }
}
