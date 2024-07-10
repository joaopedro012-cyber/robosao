import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:universal_ble/universal_ble.dart';

void main() {
  runApp(const ControlePage());
}

const ballSize = 20.0;
const step = 10.0;

const deviceIdHorizontal = "ID_AQUI_DENTRO";
const serviceIdHorizontal = "ID_AQUI_DENTRO";
const characteristicIdHorizontal = "ID_AQUI_DENTRO";

const deviceIdVertical = "ID_AQUI_DENTRO";
const serviceIdVertical = "ID_AQUI_DENTRO";
const characteristicIdVertical = "ID_AQUI_DENTRO";

 List<BleDevice> pairedDevices = [];

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;
  

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: JoystickArea(
          mode: _joystickMode,
          includeInitialAnimation: false,
          initialJoystickAlignment: const Alignment(0, 0.8),
          listener: (details) {
            setState(() {
              double ValorHorizontal = details.x;
              double ValorVertical  = details.y;

              switch(ValorHorizontal){
                case >= 0.000000000000001:
                  // String? ValorDeEnvioDireita = "D";
                  // final ValorConvertidoASCIIDireita = ValorDeEnvioDireita.codeUnitAt(0);
                  // final ValorModeloBluetoothDireita = Uint8List.fromList([ValorConvertidoASCIIDireita]);

                  // UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothDireita,BleOutputProperty.withResponse,);
                  print("Valor de X: é positivo $ValorHorizontal");
                break;
                case <= -0.000000000000001:
                  // String? ValorDeEnvioEsquerda = "A";
                  // final ValorConvertidoASCIIEsquerda = ValorDeEnvioEsquerda.codeUnitAt(0);
                  // final ValorModeloBluetoothEsquerda = Uint8List.fromList([ValorConvertidoASCIIEsquerda]);

                  // UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothEsquerda,BleOutputProperty.withResponse,);
                  print("Valor de X: é negativo $ValorHorizontal");
              }
              switch(ValorVertical){
                case >= 0.000000000000001:
                // String? ValorDeEnvioAtras = "S";
                //   final ValorConvertidoASCIIAtras = ValorDeEnvioAtras.codeUnitAt(0);
                //   final ValorModeloBluetoothAtras = Uint8List.fromList([ValorConvertidoASCIIAtras]);
                //   UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothAtras,BleOutputProperty.withResponse,);


                  print("Valor de Y: é positivo $ValorVertical");
                break;
                case <= -0.000000000000001:
                // String? ValorDeEnvioFrente = "W";
                //   final ValorConvertidoASCIIFrente = ValorDeEnvioFrente.codeUnitAt(0);
                //   final ValorModeloBluetoothFrente = Uint8List.fromList([ValorConvertidoASCIIFrente]);
                //   UniversalBle.writeValue(deviceIdHorizontal, serviceIdHorizontal, characteristicIdHorizontal, ValorModeloBluetoothFrente,BleOutputProperty.withResponse,);


                  print("Valor de Y: é negativo $ValorVertical");
              }
              _x = _x + step * details.x;
              _y = _y + step * details.y;
            });
          },
          child: Stack(
            children: [
              Ball(_x, _y),
            ],
          ),
        ),
      ),
    );
  }
}



class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  value: JoystickMode.all, child: Text('All Directions')),
              DropdownMenuItem(
                  value: JoystickMode.horizontalAndVertical,
                  child: Text('Vertical And Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.horizontal, child: Text('Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.vertical, child: Text('Vertical')),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}