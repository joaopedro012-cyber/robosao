#include <Arduino.h>
#include <SoftwareSerial.h>

/* VERTICAL */
#define ENA_V 13
#define PUL_V 12
#define DIR_V 11

// Define os pinos para RX e TX
const int rxPin = A0;
const int txPin = A1;

// Cria uma instância da classe SoftwareSerial
SoftwareSerial serialbluetooth(rxPin, txPin); // RX, TX

#define delayMs 45
#define pulsosVert 300
#define pulsosDiagonais 3200

void setup()
{
   pinMode(DIR_V, OUTPUT);
   pinMode(PUL_V, OUTPUT);
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

   if (recebidoMonitorSerial == 'a' || recebidoMonitorSerial == 'A')
   {
      digitalWrite(DIR_V, HIGH);
      for (int h = 0; h < pulsosVert; h++)
      { // Gere pulsosHoriz para girar o motor
         digitalWrite(PUL_V, HIGH);
         delayMicroseconds(delayMs); // Ajuste a velocidade aqui
         digitalWrite(PUL_V, LOW);
         delayMicroseconds(delayMs);
      }
   }
   else if (recebidoMonitorSerial == 'd' || recebidoMonitorSerial == 'D')
   {
      digitalWrite(DIR_V, LOW);
      for (int r = 0; r < pulsosVert; r++)
      { // Gere pulsosHoriz para girar o motor
         digitalWrite(PUL_V, HIGH);
         delayMicroseconds(delayMs); // Ajuste a velocidade aqui
         digitalWrite(PUL_V, LOW);
         delayMicroseconds(delayMs);
      }
   }
}
