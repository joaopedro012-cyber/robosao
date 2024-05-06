#include <Arduino.h>

/* VERTICAL */
#define ENA_V 10
#define PUL_V 9
#define DIR_V 8

#define delayMs 45
#define pulsosVert 300
#define pulsosDiagonais 3200

void setup()
{
   pinMode(DIR_V, OUTPUT);
   pinMode(PUL_V, OUTPUT);
   Serial.begin(9600);
}

void loop()
{
   if (Serial.available())
   {
      char recebidoMonitorSerial = Serial.read();
      
      if (recebidoMonitorSerial == 'a' || recebidoMonitorSerial == 'A')
      {
         digitalWrite(DIR_V, LOW);
         for (int b = 0; b < pulsosVert; b++)
         { // Gere pulsosVert para girar o motor
            digitalWrite(PUL_V, HIGH);
            delayMicroseconds(delayMs); // Ajuste a velocidade aqui
            digitalWrite(PUL_V, LOW);
            delayMicroseconds(delayMs);
         }
      }
      if (recebidoMonitorSerial == 'd' || recebidoMonitorSerial == 'D')
      {
         digitalWrite(DIR_V, HIGH);
         for (int v = 0; v < pulsosVert; v++)
         { // Gere pulsosVert para girar o motor
            digitalWrite(PUL_V, HIGH);
            delayMicroseconds(delayMs); // Ajuste a velocidade aqui
            digitalWrite(PUL_V, LOW);
            delayMicroseconds(delayMs);
         }
      }
   }
}
