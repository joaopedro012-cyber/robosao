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
  
  // Variáveis para controle de tempo e detecção de movimento
  LatLng? ultimoMovimento; // Agora é LatLng, não DateTime
  Timer? _timer;
  bool alarmeDisparado = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Criando o player de áudio

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

          // Verifica se houve movimento
          if (ultimoMovimento == null || 
              _currentPosition.latitude != ultimoMovimento!.latitude || 
              _currentPosition.longitude != ultimoMovimento!.longitude) {
            // Se houve movimento, reinicia o contador de tempo
            if (_timer != null) {
              _timer!.cancel();
            }
            ultimoMovimento = _currentPosition;
            _iniciarContadorInatividade();
          }

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

  // Função para iniciar o contador de inatividade
  void _iniciarContadorInatividade() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (ultimoMovimento == null) return;

      final tempoInativo = DateTime.now().difference(DateTime.now());

      if (tempoInativo.inMinutes >= 10 && !alarmeDisparado) {
        // Disparar alarme
        setState(() {
          alarmeDisparado = true;
        });

        // Verifica se ainda está montado antes de disparar o alarme
        if (mounted) {
          _dispararAlarme();
        }
      }
    });
  }

  // Função para disparar o alarme com som
  void _dispararAlarme() async {
    // Reproduz o som de alarme (usando um arquivo de áudio)
    await _audioPlayer.play(AssetSource('assets/sounds/alarme.mp3')); // Caminho do arquivo de áudio

    // Verifica se ainda está montado antes de exibir o diálogo
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alarme"),
            content: const Text("Você ficou inativo por mais de 10 minutos!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    alarmeDisparado = false;
                  });
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
                  onPressed: _iniciarLocalizacao, // Botão para iniciar a atualização
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
