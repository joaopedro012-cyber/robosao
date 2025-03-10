import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> coletarDados() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado');
    }

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
  GPSModuleWidgetState createState() => GPSModuleWidgetState();
}

class GPSModuleWidgetState extends State<GPSModuleWidget> {
  final GPSModule gpsModule = GPSModule();
  String localizacao = "Aguardando...";
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  final MapController _mapController = MapController();
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
      if (mounted) {
        setState(() {
          localizacao = gpsModule.obterLocalizacao();
          _currentPosition = LatLng(gpsModule.latitude, gpsModule.longitude);
        });

        _mapController.move(_currentPosition, 16.0);

        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            gpsModule.latitude = position.latitude;
            gpsModule.longitude = position.longitude;
            localizacao = gpsModule.obterLocalizacao();
            mostrarSonar = false;
          });

          _mapController.move(_currentPosition, 16.0);
          _reiniciarContadorInatividade();
        });
      }
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
    String username = "jekdenss";
    String apiKey = "FC9BBD9E-C360-6BB6-5D45-04DE7665DB4D";
    String toNumber = "+5511939499593";
    String message = "Alerta: Robo esta parado, verificar por gentileza. Localização: Lat: ${gpsModule.latitude.toStringAsFixed(5)}, Lon: ${gpsModule.longitude.toStringAsFixed(5)}. Por favor, verifique.";


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
      appBar: AppBar(
        title: const Text('GPS Module'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              minZoom: 10.0,
              maxZoom: 20.0,
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
                    width: 40.0,
                    height: 40.0,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
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
            bottom: 70,
            left: 10,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localizacao,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _iniciarLocalizacao,
                  child: const Text('Atualizar Localização'),
                ),
              ],
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
    canvas.drawCircle(size.center(Offset.zero), size.width / 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
