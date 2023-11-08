#include <SoftwareSerial.h>

#define PUL 8
#define DIR 9
#define ENA 10

SoftwareSerial serial1(5, 6); /* RX, TX */

void setup() {
  Serial.begin(19200);
  serial1.begin(4800);

  pinMode(PUL, OUTPUT);
  pinMode(DIR, OUTPUT);
  pinMode(ENA, OUTPUT);
}

void loop() {
  digitalWrite(ENA, LOW); // Habilita o driver
  
  if (Serial.available()) {
    char recebidoBluetooth = Serial.read();
    if (recebidoBluetooth = 'W') {
      digitalWrite(DIR, HIGH); // Define a direção do motor
      digitalWrite(PUL, HIGH);
      Serial.println("W");
      }
      else if (recebidoBluetooth == 'S'){
      digitalWrite(DIR, LOW); // Define a direção do motor  
      digitalWrite(PUL, LOW);
      Serial.println("S");
      }
    }

}
