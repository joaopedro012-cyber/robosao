import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Classe responsável por obter a localização GPS do dispositivo.
class GPSModule {
  double latitude = 0.0;
  double longitude = 0.0;

  // Método para coletar os dados de localização do GPS.
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

  // Método para retornar a localização no formato string.
  String obterLocalizacao() {
    return 'Lat: ${latitude.toStringAsFixed(5)}, Lon: ${longitude.toStringAsFixed(5)}';
  }
}

// Widget principal do módulo GPS, que exibe o mapa e a localização atual.
class GPSModuleWidget extends StatefulWidget {
  const GPSModuleWidget({super.key});

  @override
  GPSModuleWidgetState createState() => GPSModuleWidgetState();
}

class GPSModuleWidgetState extends State<GPSModuleWidget> {
  final GPSModule gpsModule = GPSModule();  // Instância da classe GPSModule
  String localizacao = "Aguardando...";  // Texto para exibir a localização
  LatLng _currentPosition = const LatLng(0.0, 0.0);  // Posição inicial no mapa
  final MapController _mapController = MapController();  // Controlador do mapa
  Timer? _inatividadeTimer;  // Timer para inatividade
  Timer? _sonarTimer;  // Timer para o loop de sonar
  bool mostrarSonar = false;  // Flag para exibir o sonar

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacao();  // Inicia a coleta da localização ao carregar o widget
  }

  @override
  void dispose() {
    _inatividadeTimer?.cancel();
    _sonarTimer?.cancel();
    super.dispose();
  }

  // Função para iniciar a coleta de dados de localização e acompanhar mudanças
  Future<void> _iniciarLocalizacao() async {
    try {
      await gpsModule.coletarDados();
      if (mounted) {
        setState(() {
          localizacao = gpsModule.obterLocalizacao();  // Atualiza a localização exibida
          _currentPosition = LatLng(gpsModule.latitude, gpsModule.longitude);
        });

        // Move o mapa para a nova posição
        _mapController.move(_currentPosition, 16.0);

        // Configura a stream para monitorar a posição do GPS continuamente
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,  // Atualiza a posição a cada 10 metros
          ),
        ).listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            gpsModule.latitude = position.latitude;
            gpsModule.longitude = position.longitude;
            localizacao = gpsModule.obterLocalizacao();
            mostrarSonar = false;  // Desativa o sonar se o GPS for atualizado
          });

          _mapController.move(_currentPosition, 16.0);
          _reiniciarContadorInatividade();  // Reinicia o contador de inatividade
        });
      }
    } catch (e) {
      setState(() {
        localizacao = "Erro: $e";  // Exibe mensagem de erro, caso haja algum problema
      });
    }
  }

  // Função que reinicia o contador de inatividade
  void _reiniciarContadorInatividade() {
    _inatividadeTimer?.cancel();
    _sonarTimer?.cancel();

    // Se não houver atividade por 30 segundos, ativa o sonar e envia um SMS
    _inatividadeTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          mostrarSonar = true;
        });
        _iniciarSonarLoop();
        enviarSMS();  // Envia SMS de alerta
      }
    });
  }

  // Função para iniciar o loop de sonar
  void _iniciarSonarLoop() {
    _sonarTimer?.cancel();
    _sonarTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mostrarSonar) {
        setState(() {});  // Atualiza o estado para redibujar o sonar
      } else {
        timer.cancel();  // Cancela o timer quando o sonar não é necessário
      }
    });
  }

  // Função para enviar um SMS de alerta
  Future<void> enviarSMS() async {
    String username = "jekdenss";  // Usuário para autenticação
    String apiKey = "FC9BBD9E-C360-6BB6-5D45-04DE7665DB4D";  // Chave de API
    String toNumber = "+5511939499593";  // Número de destino para o SMS
    String message = "Alerta: Robo esta parado, verificar por gentileza. Localização: Lat: ${gpsModule.latitude.toStringAsFixed(5)}, Lon: ${gpsModule.longitude.toStringAsFixed(5)}. Por favor, verifique.";

    // Envio do SMS via API ClickSend
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

    // Verifica se o SMS foi enviado com sucesso
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
          // Exibe o efeito de sonar quando necessário
          if (mostrarSonar)
            Positioned.fill(
              child: CustomPaint(
                painter: SonarPainter(),
                child: Container(),
              ),
            ),
          // Painel inferior com a localização e botão de atualização
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

// CustomPainter para desenhar o efeito de sonar na tela
class SonarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues()  // Cor do sonar o withvalues ajuda no tamanho tambem
      ..style = PaintingStyle.fill;  // Preenchimento do círculo
    canvas.drawCircle(size.center(Offset.zero), size.width / 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;  // Sempre repinta o sonar
}
