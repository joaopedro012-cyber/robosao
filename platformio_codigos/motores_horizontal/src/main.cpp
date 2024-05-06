#include <Arduino.h>

/* HORIZONTAL */
#define ENA_H 13
#define PUL_H 12
#define DIR_H 11

#define delayMs 45
#define pulsosHoriz 300
#define pulsosDiagonais 3200

void setup()
{
   pinMode(DIR_H, OUTPUT);
   pinMode(PUL_H, OUTPUT);
   Serial.begin(9600);
}

void loop()
{
   if (Serial.available())
   {
      char recebidoMonitorSerial = Serial.read();
      if (recebidoMonitorSerial == 'x' || recebidoMonitorSerial == 'X')
      {
         digitalWrite(DIR_H, HIGH);
         for (int h = 0; h < pulsosHoriz; h++)
         { // Gere pulsosHoriz    para girar o motor
            digitalWrite(PUL_H, HIGH);
            delayMicroseconds(delayMs); // Ajuste a velocidade aqui
            digitalWrite(PUL_H, LOW);
            delayMicroseconds(delayMs);
         }
      }
      if (recebidoMonitorSerial == 'w' || recebidoMonitorSerial == 'W')
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
}
