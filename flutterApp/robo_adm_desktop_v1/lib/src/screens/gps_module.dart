import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> coletarDados() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Serviço de localização desativado');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissões de localização negadas');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
  }

  String obterLocalizacao() {
    return 'Lat: ${latitude.toStringAsFixed(5)}, Lon: ${longitude.toStringAsFixed(5)}';
  }
}

class GPSModuleWidget extends StatefulWidget {
  const GPSModuleWidget({super.key});

  @override
  State<GPSModuleWidget> createState() => _GPSModuleWidgetState();
}

class _GPSModuleWidgetState extends State<GPSModuleWidget> {
  final GPSModule gpsModule = GPSModule();
  final MapController _mapController = MapController();

  String localizacao = "Aguardando...";
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  Timer? _inatividadeTimer;
  Timer? _sonarTimer;
  bool mostrarSonar = false;

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _inatividadeTimer?.cancel();
    _sonarTimer?.cancel();
    super.dispose();
  }

  Future<void> _iniciarLocalizacao() async {
    try {
      await gpsModule.coletarDados();
      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(gpsModule.latitude, gpsModule.longitude);
        localizacao = gpsModule.obterLocalizacao();
      });

      _mapController.move(_currentPosition, 18);

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((position) {
        setState(() {
          gpsModule.latitude = position.latitude;
          gpsModule.longitude = position.longitude;
          _currentPosition = LatLng(position.latitude, position.longitude);
          localizacao = gpsModule.obterLocalizacao();
          mostrarSonar = false;
        });

        _mapController.move(_currentPosition, _mapController.camera.zoom);
        _reiniciarContadorInatividade();
      });
    } catch (e) {
      setState(() {
        localizacao = "Erro: $e";
      });
    }
  }

  void _reiniciarContadorInatividade() {
    _inatividadeTimer?.cancel();
    _sonarTimer?.cancel();

    _inatividadeTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          mostrarSonar = true;
        });
        _iniciarSonarLoop();
        enviarSMS();
      }
    });
  }

  void _iniciarSonarLoop() {
    _sonarTimer?.cancel();
    _sonarTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mostrarSonar) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> enviarSMS() async {
    const username = "jekdenss";
    const apiKey = "FC9BBD9E-C360-6BB6-5D45-04DE7665DB4D";
    const toNumber = "+5511939499593";
    final message =
        "Alerta: Robo está parado. Localização: Lat: ${gpsModule.latitude.toStringAsFixed(5)}, Lon: ${gpsModule.longitude.toStringAsFixed(5)}.";

    final response = await http.post(
      Uri.parse("https://rest.clicksend.com/v3/sms/send"),
      headers: {
        "Authorization": "Basic ${base64Encode(utf8.encode('$username:$apiKey'))}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "messages": [
          {
            "source": "flutter_app",
            "body": message,
            "to": toNumber,
            "from": "ClickSend",
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      print("SMS enviado com sucesso!");
    } else {
      print("Erro ao enviar SMS: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rastreamento em Tempo Real')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 18.0,
              maxZoom: 20.0,
              minZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition,
                    width: 60,
                    height: 60,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.navigation,
                        size: 50,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (mostrarSonar)
            Positioned.fill(
              child: CustomPaint(
                painter: SonarPainter(),
                child: Container(),
              ),
            ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withValues(),
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      localizacao,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _iniciarLocalizacao,
                      child: const Text("Atualizar localização"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SonarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues()
      ..style = PaintingStyle.fill;

    final center = size.center(Offset.zero);
    final radius = size.width / 3;

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius * 0.66, paint..color = Colors.red.withValues());
    canvas.drawCircle(center, radius * 0.33, paint..color = Colors.red.withValues());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
