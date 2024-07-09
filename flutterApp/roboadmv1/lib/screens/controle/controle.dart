import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_joystick/simple_joystick.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const ControlePage());
}

class ControlePage extends StatelessWidget {
  const ControlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple JoyStick Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 0, 0)),
        useMaterial3: true,
        
      ),
      home: const MyHomePage(title: ''),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Alignment currentAlignment = const Alignment(0, 0);

  @override
  Widget build(BuildContext context) {
    void move(Alignment alignment) {
      currentAlignment = alignment;
      setState(() {});
    }

    final ball = AnimatedAlign(
      alignment: currentAlignment,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25.0,
        backgroundColor: const Color.fromARGB(255, 78, 78, 78),
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 17,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
          ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ball,
            ),
            JoyStick(
              150,
              50,
              (details) {
                // nothing
                move(details.alignment);
              },
            ),
          ],
        ),
      ),
    );
  }
}
