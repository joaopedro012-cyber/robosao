#include <TinyGPSPlus.h>

// Inicializa o objeto GPS
TinyGPSPlus gps;

void setup() {
  Serial.begin(9600);  // Recebe Sensores
  Serial1.begin(9600); // Recebe Pulsos
  Serial2.begin(9600); // Recebe GPS
  Serial3.begin(9600); // Envia para o...
}

void loop() {
  // Recebe dados dos sensores
  if (Serial.available()) {
    char recebidoDeSensores = Serial.read();
    Serial.print("Recebido de Sensores: ");
    Serial.println(recebidoDeSensores);
  }

  // Recebe dados dos pulsos
  if (Serial1.available()) {
    char recebidoDePulsos = Serial1.read();
    Serial1.print("Recebido de Pulsos: ");
    Serial1.println(recebidoDePulsos);
  }

  // Recebe e processa dados do GPS
  while (Serial2.available() > 0) {
    if (gps.encode(Serial2.read())) {
      // Imprime os dados na porta serial
      Serial.println("");
      Serial.print("Latitude: ");
      Serial.println(gps.location.lat(), 6);

      Serial.print("Longitude: ");
      Serial.println(gps.location.lng(), 6);

      Serial.print("Altitude: ");
      Serial.println(gps.altitude.meters());

      Serial.print("Direção: ");
      Serial.println(gps.course.deg());

      Serial.print("Data: ");
      Serial.print(gps.date.day());
      Serial.print("/");
      Serial.print(gps.date.month());
      Serial.print("/");
      Serial.println(gps.date.year());

      Serial.print("Hora: ");
      Serial.print(gps.time.hour()-3);
      Serial.print(":");
      Serial.print(gps.time.minute());
      Serial.print(":");
      Serial.println(gps.time.second());
    }
  }

  // Aguarda um curto período para evitar a sobrecarga da CPU
  delay(1000); // Ajustado para 1 segundo, pode ser ajustado conforme necessário
}
