#include <Arduino.h>

/* HORIZONTAL */
#define ENA_PLAT 13 
#define PUL_PLAT 12
#define DIR_PLAT 11

void setup() {
  pinMode(DIR_PLAT, OUTPUT);
  pinMode(PUL_PLAT, OUTPUT);
  Serial.begin(9600);
  
}

void loop() {
  int delayMs = 22;
  if (Serial.available()){
    char recebidoMonitorSerial = Serial.read();
    if(recebidoMonitorSerial == 'j' || recebidoMonitorSerial == 'J'){
    digitalWrite(DIR_PLAT, HIGH);
     for (int b = 0; b < 10000; b++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_PLAT, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_PLAT, LOW);
        delayMicroseconds(delayMs);
     }
    }
    if(recebidoMonitorSerial == 'm' || recebidoMonitorSerial == 'M'){
    digitalWrite(DIR_PLAT, LOW);
     for (int v = 0; v < 10000; v++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_PLAT, HIGH);
        delayMicroseconds(delayMs); // Ajuste a velocidade aqui
        digitalWrite(PUL_PLAT, LOW);
        delayMicroseconds(delayMs);
     }
    }
  }
  }