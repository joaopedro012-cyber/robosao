import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roboadmv1/screens/home.dart';

void main() {
  runApp(const RotinasPage());
}

class RotinasPage extends StatefulWidget {
  const RotinasPage({super.key});

  @override
  State<RotinasPage> createState() => _RotinasPageState();
}

class _RotinasPageState extends State<RotinasPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 213, 113, 113),
          title: const Text(
            'Rotinas',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Define o padding
          child: Center(
            child: Wrap(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.69,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFd57171),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                        hintText: 'Nova rotina...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd57171),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(55, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Icon(CupertinoIcons.plus),
                  ),
                ),
                const Flexible(
                  flex: 20,
                  child: Text(
                    "ROTINAS EXISTENTES:",
                    style: TextStyle(
                      color: const Color(0xFFd57171),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                ),
                Divider(color: const Color(0xFFd57171)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
