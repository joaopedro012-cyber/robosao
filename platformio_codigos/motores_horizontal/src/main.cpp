#include <Arduino.h>
#include <SoftwareSerial.h>

/* HORIZONTAL */
#define ENA_H 13
#define PUL_H 12
#define DIR_H 11

// Define os pinos para RX e TX
const int rxPin = A0;
const int txPin = A1;

// Cria uma instância da classe SoftwareSerial
SoftwareSerial serialbluetooth(rxPin, txPin); // RX, TX

#define delayMs 45
#define pulsosHoriz 1000
#define pulsosDiagonais 3200

void setup()
{
   pinMode(DIR_H, OUTPUT);
   pinMode(PUL_H, OUTPUT);
   serialbluetooth.begin(9600);
   Serial.begin(9600);
}

void loop()
{
   char recebidoMonitorSerial = 0;

   if (Serial.available())
   {
      recebidoMonitorSerial = Serial.read();
   }
   else if (serialbluetooth.available())
   {
      recebidoMonitorSerial = serialbluetooth.read();
   }

   if (recebidoMonitorSerial == 'x' || recebidoMonitorSerial == 'X')
   {
      digitalWrite(DIR_H, HIGH);
      for (int h = 0; h < pulsosHoriz; h++)
      { // Gere pulsosHoriz para girar o motor
         digitalWrite(PUL_H, HIGH);
         delayMicroseconds(delayMs); // Ajuste a velocidade aqui
         digitalWrite(PUL_H, LOW);
         delayMicroseconds(delayMs);
      }
   }
   else if (recebidoMonitorSerial == 'w' || recebidoMonitorSerial == 'W')
   {
      digitalWrite(DIR_H, LOW);
      for (int r = 0; r < pulsosHoriz; r++)
      { // Gere pulsosHoriz para girar o motor
         digitalWrite(PUL_H, HIGH);
         delayMicroseconds(delayMs); // Ajuste a velocidade aqui
         digitalWrite(PUL_H, LOW);
         delayMicroseconds(delayMs);
      }
   }
}
