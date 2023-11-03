#include <SPI.h>
#include <SD.h>

File myFile;

void setup() {
  Serial.begin(9600);  // Inicia a comunicação serial a 4800 baud
  if (!SD.begin(4)) {
    Serial.println("Falha na inicialização do cartão SD");
    return;
  }
}

void loop() {
  if (Serial.available()) {  // Se há dados disponíveis para leitura
    int distance01 = Serial.parseInt();  // Lê o valor de distance01 do outro Arduino

    long currentMillis = millis();

    myFile = SD.open("mlsensores.csv", FILE_WRITE);
  
    if (myFile) {
      myFile.print(currentMillis);
      myFile.print(",");
      myFile.println(distance01);
      myFile.close();
      Serial.println("Dados escritos no arquivo mlsensores.csv");
    } else {
      Serial.println("Erro ao abrir o arquivo mlsensores.csv");
    }
  }
}
