#include <Arduino.h>
#include <SoftwareSerial.h>

/* HORIZONTAL */
#define ENA_H 13
#define PUL_H 12
#define DIR_H 11

SoftwareSerial serialfisico(10, 9);     // RX, TX
SoftwareSerial serialbluetooth(A1, A0); // RX, TX

#define delayMs 45
#define pulsosHoriz 300
#define pulsosDiagonais 3200

void setup()
{
   pinMode(DIR_H, OUTPUT);
   pinMode(PUL_H, OUTPUT);
   serialbluetooth.begin(9600);
   serialfisico.begin(9600);
   Serial.begin(9600);
}

void loop()
{
   if (Serial.available())
   {
      char recebidoMonitorSerial = serialfisico.read() || serialbluetooth.read();
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
