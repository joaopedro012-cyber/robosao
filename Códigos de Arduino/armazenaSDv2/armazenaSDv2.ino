#include <SoftwareSerial.h>

#define rxPin 10
#define txPin 11

SoftwareSerial serialCustom(rxPin, txPin);

void setup() {
  Serial.begin(9600);
  serialCustom.begin(9600);
}

void loop() {
  if (serialCustom.available()) {
    char recebido = serialCustom.read();
    Serial.print("Recebido: ");
    Serial.println(recebido);
  }
}
