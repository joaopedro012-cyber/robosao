#include <TinyGPSPlus.h>
#include <SPI.h>
#include <SD.h>

// Inicializa o objeto GPS
TinyGPSPlus gps;

// Inicializa o SDCard
File myFile;

void setup() {
  Serial.begin(9600);  // SENSORES
  Serial1.begin(9600); // PULSO
  Serial2.begin(9600); // GPS
  Serial3.begin(9600); // SD
  while (!Serial3) {
    ; 
  }
  Serial3.print("Inicializando o SD card...");

  if (!SD.begin(4)) {
    Serial3.println("Falha na inicialização do SD.");
    while (1);
  }
  Serial3.println("Inicialização do SD concluída.");

  myFile = SD.open("armazena.csv", FILE_WRITE);
  if (!myFile) {
    Serial3.println("Erro ao abrir o arquivo armazena.csv para escrita.");
    while (1);
  }
  Serial3.println("Arquivo aberto com sucesso.");
}

void loop() {
  // Recebe dados dos sensores
  if (Serial1.available()) {
    char recebidoDeSensores = Serial.read();
    Serial.print("Recebido de Sensores: ");
    Serial.println(recebidoDeSensores);
    if (myFile) {
      myFile.println(recebidoDeSensores);
    } else {
      Serial3.println("Erro ao escrever no arquivo.");
    }
  }

  // Recebe dados dos pulsos
  if (Serial.available()) {
    Serial.println("Pulsos estão ativos");
    char recebidoDePulsos = Serial.read();
    Serial1.print("Recebido de Pulsos: ");
    Serial1.println(recebidoDePulsos);
    if (myFile) {
      myFile.println(recebidoDePulsos);
    } else {
      Serial3.println("Erro ao escrever no arquivo.");
    }
  }
  else {
    Serial.println("Não iniciado os pulsos.");
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
    } else {
      Serial3.println("Erro na leitura do GPS.");
    }
  }

  myFile.close();  // Fechar o arquivo após escrever os dados

  delay(1000); 
}
