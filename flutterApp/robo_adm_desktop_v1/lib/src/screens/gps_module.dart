import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart'; // Para detectar a plataforma
import 'dart:io';

class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> coletarDados() async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) {
      latitude = -23.5505; // São Paulo, exemplo
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
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw Exception('Permissões de localização negadas');
        }
      }
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

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacao();
  }

  // Função para obter a localização inicial e começar a escutar em tempo real
  Future<void> _iniciarLocalizacao() async {
    try {
      await gpsModule.coletarDados();
      if (mounted) {
        setState(() {
          localizacao = gpsModule.obterLocalizacao();
          _currentPosition = LatLng(gpsModule.latitude, gpsModule.longitude);
        });

        _mapController.move(_currentPosition, 16.0);

        // Iniciar o stream para atualização contínua da posição
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter:
                10, // Distância mínima para atualizações (em metros)
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            localizacao = gpsModule.obterLocalizacao();
          });

          // Move o mapa para a nova posição em tempo real
          _mapController.move(_currentPosition, 16.0);
        });
      }
    } catch (e) {
      setState(() {
        localizacao = "Erro: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Module'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition, // Use 'initialCenter' aqui
              initialZoom: 16.0, // Use 'initialZoom' aqui
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
          // Texto "Norte" no topo do mapa
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.white.withOpacity(0.7),
                child: const Text(
                  "Norte",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Texto "Sul" na parte inferior do mapa
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.white.withOpacity(0.7),
                child: const Text(
                  "Sul",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Texto "Leste" no lado direito do mapa
          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.white.withOpacity(0.7),
                  child: const Text(
                    "Leste",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Texto "Oeste" no lado esquerdo do mapa
          Positioned(
            top: 0,
            bottom: 0,
            left: 10,
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.white.withOpacity(0.7),
                  child: const Text(
                    "Oeste",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Informações e botão na parte inferior
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
                  onPressed:
                      _iniciarLocalizacao, // Botão para iniciar a atualização
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
