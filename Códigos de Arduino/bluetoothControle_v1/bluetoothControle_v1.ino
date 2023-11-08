#define PUL 8
#define DIR 9
#define ENA 10

#include <Dabble.h>

void setup() {
  Serial.begin(9600);
  
  pinMode(PUL, OUTPUT);
  pinMode(DIR, OUTPUT);
  pinMode(ENA, OUTPUT);
}

void loop() {
  digitalWrite(ENA, LOW); // Habilita o driver
  
  if (Serial.available()) {
    char recebidoBluetooth = Serial.read();
    //Serial.println(recebidoBluetooth);
    if (recebidoBluetooth == 'W') {
      digitalWrite(DIR, HIGH); // Define a direção do motor
      Serial.println("W");
      for (int i = 0; i < 200; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL, LOW);
        delayMicroseconds(500);
      }
    }
    else if (recebidoBluetooth == 'S'){
      digitalWrite(DIR, LOW); // Define a direção do motor
      //Serial.println("S");
      for (int i = 0; i < 200; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL, LOW);
        delayMicroseconds(500);
      }
      
    }
  }
}
