#include <Arduino.h>
#include <TinyGPS++.h>
#include <TinyGPSPlus.h>
#include <SoftwareSerial.h>

// Configura os pinos RX e TX
static const int RXPin = 4, TXPin = 3;

// Configura a velocidade de transmissão de dados (baud rate)
static const uint32_t GPSBaud = 9600;

// Configura o objeto TinyGPSPlus
TinyGPSPlus gps;

// Configura o objeto SoftwareSerial
SoftwareSerial ss(RXPin, TXPin);

void setup() {
  Serial.begin(9600);
  ss.begin(GPSBaud);
}

void loop() {
  Serial.print("INICIALIZADO COM SUCESSO"); 
  // Verifica se há novos dados disponíveis no módulo GPS
  while (ss.available() > 0) {
    gps.encode(ss.read());
    if (gps.location.isUpdated()) {
      // Imprime as coordenadas de latitude e longitude
      Serial.print("Latitude= "); 
      Serial.print(gps.location.lat(), 6);
      Serial.print(" Longitude= "); 
      Serial.println(gps.location.lng(), 6);
    }
  }
}
