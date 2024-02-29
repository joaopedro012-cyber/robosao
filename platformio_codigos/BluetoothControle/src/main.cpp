#include <Arduino.h>
#include <SoftwareSerial.h>

/* serialCustom */
#define rxPin A0
#define txPin A1
/* HORIZONTAL */
#define PUL_H 8
#define DIR_H 9
#define ENA_H 10 
/* VERTICAL */
#define PUL_V 11
#define DIR_V 12
#define ENA_V 13

SoftwareSerial serialCustom(rxPin, txPin);

void setup() {
  Serial.begin(9600);
  serialCustom.begin(9600);
  /* Ativa Motores de Pulso */
  digitalWrite(ENA_H, LOW); 
  digitalWrite(ENA_V, LOW); 
  
  /* Define a saída dos pinos */
  pinMode(PUL_H, OUTPUT);
  pinMode(DIR_H, OUTPUT);
  pinMode(ENA_H, OUTPUT);
  pinMode(PUL_V, OUTPUT);
  pinMode(DIR_V, OUTPUT);
  pinMode(ENA_V, OUTPUT);
}

void loop() {
  if (serialCustom.available()) {
    //String recebidoBluetooth = serialCustom.readStringUntil('');
    char recebidoBluetooth = serialCustom.read();
    //serialCustom.println(recebidoBluetooth);
    if (recebidoBluetooth == 'W') {
      Serial.write('W'); 
      serialCustom.print('w');
      delay(10);
      digitalWrite(DIR_H, HIGH); // Define a direção do motor
      for (int i = 0; i < 25600; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_H, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_H, LOW);
        delayMicroseconds(90);
    }
  }
  else if (recebidoBluetooth == 'Q') {
      Serial.write('Q'); 
      serialCustom.print('Q');
      delay(10);
      digitalWrite(DIR_H, HIGH); // Define a direção do motor
      digitalWrite(DIR_V, HIGH);
      for (int i = 0; i < 100; i++) { // Gere pulsos para girar o motor
        digitalWrite(PUL_V, HIGH);
        delayMicroseconds(90); // Ajuste a velocidade aqui
        digitalWrite(PUL_V, LOW);
        delayMicroseconds(90);
        
    }
  }
 }
}
/* 25600 - HORIZONTAL*/
/* 1600 - VERTICAL*/
/* 800 - PLATAFORMA*/
/* 
#define rxPin A0
#define txPin A1
 */
