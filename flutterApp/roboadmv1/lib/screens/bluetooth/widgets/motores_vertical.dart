// import 'dart:async';
// import 'package:roboadmv1/screens/home.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_classic/flutter_blue_classic.dart';
// import 'package:roboadmv1/screens/bluetooth/widgets/conexao_motor_vertical.dart';

// void main() {
//   runApp(const MotoresVerticalConexao());
// }

// class MotoresVerticalConexao extends StatelessWidget {
//   const MotoresVerticalConexao({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: VerticalJoytick(),
//     );
//   }
// }

// class VerticalJoytick extends StatefulWidget {
//   const VerticalJoytick({super.key});

//   @override
//   State<VerticalJoytick> createState() => _VerticalJoytickState();
// }

// class _VerticalJoytickState extends State<VerticalJoytick> {
//   final _BluetoothClassicVertical = FlutterBlueClassic();

//   BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
//   StreamSubscription? _adapterStateSubscription;

//   final Set<BluetoothDevice> _scanResults = {};
//   StreamSubscription? _scanSubscription;

//   bool _isScanning = false;
//   StreamSubscription? _scanningStateSubscription;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     BluetoothAdapterState adapterState = _adapterState;

//     try {
//       adapterState = await _BluetoothClassicVertical.adapterStateNow;
//       _adapterStateSubscription =
//           _BluetoothClassicVertical.adapterState.listen((current) {
//         if (mounted) setState(() => _adapterState = current);
//       });
//       _scanSubscription =
//           _BluetoothClassicVertical.scanResults.listen((device) {
//         if (mounted) setState(() => _scanResults.add(device));
//       });
//       _scanningStateSubscription =
//           _BluetoothClassicVertical.isScanning.listen((isScanning) {
//         if (mounted) setState(() => _isScanning = isScanning);
//       });
//     } catch (e) {
//       if (kDebugMode) print(e);
//     }

//     if (!mounted) return;

//     setState(() {
//       _adapterState = adapterState;
//     });
//   }

//   @override
//   void dispose() {
//     _adapterStateSubscription?.cancel();
//     _scanSubscription?.cancel();
//     _scanningStateSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<BluetoothDevice> scanResults = _scanResults.toList();

//     return Scaffold(
//       body: ListView(
//         children: [
//           if (scanResults.isEmpty)
//             const Center(child: Text("Dispositivos não encontrados"))
//           else
//             for (var result in scanResults)
//               ListTile(
//                 title: Text("${result.name ?? "???"}"),
//                 trailing: Text("${result.rssi} dBm"),
//                 onTap: () async {
//                   BluetoothConnection? connection;
//                   try {
//                     connection =
//                         await _BluetoothClassicVertical.connect(result.address);
//                     if (!this.context.mounted) return;
//                     if (connection != null && connection.isConnected) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ConexaoMotorVertical(
//                                   connection: connection!)));
//                     }
//                   } catch (e) {
//                     if (kDebugMode) print(e);
//                     connection?.dispose();
//                     ScaffoldMessenger.maybeOf(context)?.showSnackBar(
//                         const SnackBar(
//                             content: Text("Erro ao conectar ao dispositivo")));
//                   }
//                 },
//               )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (_isScanning) {
//             _BluetoothClassicVertical.stopScan();
//           } else {
//             _scanResults.clear();
//             _BluetoothClassicVertical.startScan();
//           }
//         },
//         label: Text(_isScanning ? "Procurando..." : "Buscar"),
//         icon:
//             Icon(_isScanning ? Icons.bluetooth_searching : Icons.manage_search),
//       ),
//     );
//   }
// }
