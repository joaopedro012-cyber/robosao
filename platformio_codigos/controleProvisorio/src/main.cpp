#include <Arduino.h>

/* HORIZONTAL */
#define ENA_H 13 
#define PUL_H 12
#define DIR_H 11
/* VERTICAL */
#define ENA_V 10
#define PUL_V 9
#define DIR_V 8 

#define delayMs 45
#define pulsosHoriz 6400
#define pulsosVert 300
#define pulsosDiagonais 3200

void setup() {
  pinMode(DIR_H, OUTPUT);
  pinMode(PUL_H, OUTPUT);
  pinMode(DIR_V, OUTPUT);
  pinMode(PUL_V, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()){
    char recebidoMonitorSerial = Serial.read();
    if(recebidoMonitorSerial == 'x' || recebidoMonitorSerial == 'X'){
    digitalWrite(DIR_H, HIGH);
     for (int b = 0; b < pulsosVert; b++) { // Gere pulsosVert para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'w' || recebidoMonitorSerial == 'W'){
    digitalWrite(DIR_H, LOW);
     for (int v = 0; v < pulsosVert; v++) { // Gere pulsosVert para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'e' || recebidoMonitorSerial == 'E'){
    for (int v = 0; v < pulsosDiagonais; v++) {
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
      int c = 0;
      int d = pulsosHoriz;
         while (c < d) {
            if (Serial.available() > 0) {
               digitalWrite(DIR_V, HIGH);
               digitalWrite(PUL_V, HIGH);
               delayMicroseconds(delayMs); // Ajuste a velocidade aqui
               digitalWrite(PUL_V, LOW);
               digitalWrite(DIR_V, HIGH);
               digitalWrite(PUL_V, HIGH);
               delayMicroseconds(delayMs); // Ajuste a velocidade aqui
               digitalWrite(PUL_V, LOW);
               
               d+= pulsosDiagonais;
            }
      }
     }
     for (int v = 0; v < pulsosVert; v++) {
        digitalWrite(DIR_V, LOW);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
    }
    }
    if(recebidoMonitorSerial == 'q' || recebidoMonitorSerial == 'Q'){
    digitalWrite(DIR_H, HIGH);
     for (int o = 0; o < pulsosVert; o++) {
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int z = 0; z < pulsosVert; z++) { // Gere pulsosVert para girar o motor
        delayMicroseconds(delayMs);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'a' || recebidoMonitorSerial == 'A'){
    digitalWrite(DIR_V, LOW);
     for (int b = 0; b < pulsosVert; b++) { // Gere pulsosVert para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'd' || recebidoMonitorSerial == 'D'){
    digitalWrite(DIR_V, HIGH);
     for (int v = 0; v < pulsosVert; v++) { // Gere pulsosVert para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'z' || recebidoMonitorSerial == 'Z'){
    digitalWrite(DIR_H, HIGH);
     for (int c = 0; c < pulsosVert; c++) {
        digitalWrite(DIR_V, LOW);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
     for (int x = 0; x < pulsosVert; x++) { // Gere pulsosVert para girar o motor
        delayMicroseconds(delayMs);
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'c' || recebidoMonitorSerial == 'C'){
    digitalWrite(DIR_H, HIGH);
     for (int o = 0; o < pulsosVert; o++) {
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        digitalWrite(DIR_V, HIGH);
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);

     }
  }
  } 
  }