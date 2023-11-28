// Inclua as bibliotecas necessárias
#include <SPI.h>
#include <SD.h>

// Defina o pino CS
const int chipSelect = 4;
File meuArquivo;

void setup() {
  Serial.begin(9600);/* Recebe Sensores */
  Serial1.begin(9600);/* Recebe Pulsos */
  Serial2.begin(9600);/* Escreve no cartão de memória */

  // Verifique se o cartão SD está presente e pode ser inicializado
  if (!SD.begin(chipSelect)) {
    Serial2.println("Falha ao inicializar o cartão SD");
    return;
  }

  // Se tudo estiver bem, imprima uma mensagem de sucesso
  Serial2.println("Cartão SD inicializado com sucesso");
}

void loop() {
  if (Serial1.available()) {
    char recebidoDeSensres = Serial1.read();
    Serial.print("Recebido de sensores: ");
    Serial.println(recebidoDeSensres);

    meuArquivo = SD.open("dados.txt", FILE_WRITE);

    if (meuArquivo) {
      meuArquivo.print("pulso,");
      meuArquivo.println(recebidoDeSensres);
      meuArquivo.close();
    } else {
      Serial.println("Erro ao abrir o arquivo dados.csv");
    }
  }
}
