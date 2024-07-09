  import "package:flutter/material.dart";
  

class BotaoComIcone extends StatefulWidget {
  final IconData icone;
  final String textoIcone;
  final Color corDeFundo;
  final VoidCallback onPressed;
  const BotaoComIcone(
      {Key? key,
      required this.icone,
      required this.textoIcone,
      required this.corDeFundo,
      required this.onPressed})
      : super(key: key);

  @override
  State<BotaoComIcone> createState() => _BotaoComIconeState();
}

class _BotaoComIconeState extends State<BotaoComIcone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
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
            Text(
              widget.textoIcone.toUpperCase(),
              style: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        label: Text(''),
      ),
    );
  }
}
