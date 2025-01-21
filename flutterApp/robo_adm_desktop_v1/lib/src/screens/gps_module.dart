import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart'; // Para detectar a plataforma
import 'dart:io';
import 'dart:async'; // Para usar o Timer
import 'package:audioplayers/audioplayers.dart'; // Importando o pacote de áudio

class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> coletarDados() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      // Para plataformas web ou desconhecidas
      latitude = -23.5505; // São Paulo (exemplo)
      longitude = -46.6333;
    } else {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Serviço de localização desativado');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Permissões de localização negadas');
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }
  }

  String obterLocalizacao() {
    String latDirection = latitude >= 0 ? 'Norte' : 'Sul';
    String lonDirection = longitude >= 0 ? 'Leste' : 'Oeste';

    return 'Latitude: ${latitude.abs()}° $latDirection, Longitude: ${longitude.abs()}° $lonDirection';
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

  LatLng? ultimoMovimento;
  Timer? _timer;
  bool alarmeDisparado = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
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
          });

          if (ultimoMovimento == null ||
              _currentPosition.latitude != ultimoMovimento!.latitude ||
              _currentPosition.longitude != ultimoMovimento!.longitude) {
            if (_timer != null) {
              _timer!.cancel();
            }
            ultimoMovimento = _currentPosition;
            _iniciarContadorInatividade();
          }

          _mapController.move(_currentPosition, 16.0);
        });
      }
    } catch (e) {
      setState(() {
        localizacao = "Erro: $e";
      });
    }
  }

  void _iniciarContadorInatividade() {
    _timer = Timer(const Duration(minutes: 2), () {
      if (!alarmeDisparado && mounted) {
        setState(() {
          alarmeDisparado = true;
        });
        _dispararAlarme();
      }
    });
  }

  void _dispararAlarme() async {
    await _audioPlayer.play(AssetSource('lib/src/assets/sounds/alarme.mp3'));
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alarme"),
            content: const Text("O robô está parado!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    alarmeDisparado = false;
                  });
                  _audioPlayer.stop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Module'),
        backgroundColor: const Color.fromARGB(235, 253, 253, 253),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
          Positioned(
            bottom: 70,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Text(
                  localizacao,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GPSModuleWidget(),
    ),
  );
}
