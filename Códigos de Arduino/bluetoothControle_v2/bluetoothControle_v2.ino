#include <SoftwareSerial.h>

#define rxPin A0
#define txPin A1

#define PUL_H 8
#define DIR_H 9
#define ENA_H 10 

#define PUL_V 11
#define DIR_V 12
#define ENA_V 13

SoftwareSerial serialCustom(rxPin, txPin);

void setup() {
  serialCustom.begin(9600);
  Serial.begin(9600);
  
  pinMode(PUL_H, OUTPUT);
  pinMode(DIR_H, OUTPUT);
  pinMode(ENA_H, OUTPUT);
  pinMode(PUL_V, OUTPUT);
  pinMode(DIR_V, OUTPUT);
  pinMode(ENA_V, OUTPUT);
}

void loop() {
  digitalWrite(ENA_H, LOW); // Habilita o driver
  digitalWrite(ENA_V, LOW); // Habilita o driver
  if (serialCustom.available()) {
    char recebidoBluetooth = serialCustom.read();
    //serialCustom.println(recebidoBluetooth);
    if (recebidoBluetooth == 'W') {
      Serial.write('W'); 
      serialCustom.print('w');
      delay(10);
      digitalWrite(DIR_H, HIGH); // Define a direção do motor
      for (int i = 0; i < 200; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(500);
      }
    }
    else if (recebidoBluetooth == 'S'){
      Serial.write('S');
      serialCustom.print('s');
      delay(10);
      digitalWrite(DIR_H, LOW); // Define a direção do motor
      for (int i = 0; i < 200; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(500);
      }
      
    }
    else if (recebidoBluetooth == 'A'){
      Serial.write('A'); 
      serialCustom.print('a');
      delay(10);
      digitalWrite(DIR_V, LOW); // Define a direção do motor
      for (int i = 0; i < 400; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(500);
      }
      
    }
    else if (recebidoBluetooth == 'D'){
      Serial.write('D');
      serialCustom.print('d');
      delay(10);
      digitalWrite(DIR_V, HIGH); // Define a direção do motor
      for (int i = 0; i < 1000; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(500); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(500);
      }
      
    }
  }
}
