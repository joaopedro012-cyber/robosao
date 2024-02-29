#include <Arduino.h>

/* HORIZONTAL */
#define ENA_H 13 
#define PUL_H 12
#define DIR_H 11
/* VERTICAL */
#define ENA_V 10
#define PUL_V 9
#define DIR_V 8 

void setup() {
  pinMode(DIR_H, OUTPUT);
  pinMode(PUL_H, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()){
    String recebidoMonitorSerial = Serial.readString();
    if(recebidoMonitorSerial == "w" || recebidoMonitorSerial == "W"){
    digitalWrite(DIR_H, HIGH);
     for (int i = 0; i < 1600; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == "x" || recebidoMonitorSerial == "X"){
    digitalWrite(DIR_H, LOW);
     for (int i = 0; i < 1600; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == "e" || recebidoMonitorSerial == "E"){
    digitalWrite(DIR_H, HIGH);
     for (int o = 0; o < 1066; o++) {
        digitalWrite(DIR_V, LOW);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int i = 0; i < 1600; i++) { // Gere pulsos para girar o motor
        delayMicroseconds(90);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == "q" || recebidoMonitorSerial == "Q"){
    digitalWrite(DIR_H, HIGH);
     for (int o = 0; o < 1066; o++) {
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int i = 0; i < 1600; i++) { // Gere pulsos para girar o motor
        delayMicroseconds(90);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
  }
}
