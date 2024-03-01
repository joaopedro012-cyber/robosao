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
    char recebidoMonitorSerial = Serial.read();
    if(recebidoMonitorSerial == 'w' || recebidoMonitorSerial == 'W'){
    digitalWrite(DIR_H, HIGH);
     for (int b = 0; b < 25600; b++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'x' || recebidoMonitorSerial == 'X'){
    digitalWrite(DIR_H, LOW);
     for (int v = 0; v < 25600; v++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'e' || recebidoMonitorSerial == 'E'){
    digitalWrite(DIR_H, HIGH);
     for (int c = 0; c < 1066; c++) {
        digitalWrite(DIR_V, LOW);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int x = 0; x < 1600; x++) { // Gere pulsos para girar o motor
        delayMicroseconds(90);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'q' || recebidoMonitorSerial == 'Q'){
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
     for (int z = 0; z < 1600; z++) { // Gere pulsos para girar o motor
        delayMicroseconds(90);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'd' || recebidoMonitorSerial == 'D'){
    digitalWrite(DIR_V, HIGH);
     for (int b = 0; b < 1600; b++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'a' || recebidoMonitorSerial == 'A'){
    digitalWrite(DIR_V, LOW);
     for (int v = 0; v < 1600; v++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'z' || recebidoMonitorSerial == 'Z'){
    digitalWrite(DIR_H, HIGH);
     for (int c = 0; c < 1066; c++) {
        digitalWrite(DIR_V, LOW);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int x = 0; x < 1600; x++) { // Gere pulsos para girar o motor
        delayMicroseconds(90);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
     }
    }
    if(recebidoMonitorSerial == 'c' || recebidoMonitorSerial == 'C'){
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
  }
  }
}
