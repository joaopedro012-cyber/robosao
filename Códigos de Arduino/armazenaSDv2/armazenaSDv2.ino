#include <SD.h>

void setup() {
  Serial.begin(9600);
  Serial1.begin(4800);
}

void loop() {
  if (Serial1.available()) {
    char valoresRecebidos1 = Serial1.read();
    Serial1.print(valoresRecebidos1); // Use Serial.print() em vez de Serial1.println()
  }
}
