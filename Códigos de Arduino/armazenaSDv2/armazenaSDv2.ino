#include <SD.h>

void setup() {
  Serial.begin(9600);

}

void loop() {
  if(Serial.available()>0) {
    int valoresRecebidos = Serial.read();
    Serial.println(valoresRecebidos);
  }
}
