/* BIBLIOTECAS COMEÇO */
#include <Arduino.h>
#include <NewPing.h>
/* BIBLIOTECAS FINAL */

#define SONAR_NUM 12     /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 200 /* DISTÂNCIA MÁXIMA DE 200 CM */

/* ENTRADA E SAÍDA DE SENSORES COMEÇO */
NewPing sensor01(23, 22, MAX_DISTANCE);
NewPing sensor02(25, 24, MAX_DISTANCE);
NewPing sensor03(27, 26, MAX_DISTANCE);
NewPing sensor04(29, 28, MAX_DISTANCE);
NewPing sensor05(31, 30, MAX_DISTANCE);
NewPing sensor06(33, 32, MAX_DISTANCE);
NewPing sensor07(35, 34, MAX_DISTANCE);
NewPing sensor08(37, 36, MAX_DISTANCE);
NewPing sensor09(39, 38, MAX_DISTANCE);
NewPing sensor10(41, 40, MAX_DISTANCE);
NewPing sensor11(43, 42, MAX_DISTANCE);
NewPing sensor12(45, 44, MAX_DISTANCE);
/* ENTRADA E SAÍDA DE SENSORES FIM */

void setup()
{
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop()
{
      /* Serial.write(sensor01.ping_cm());
      Serial.write(sensor02.ping_cm());
      Serial.write(sensor03.ping_cm());
      Serial.write(sensor04.ping_cm());
      Serial.write(sensor05.ping_cm());
      Serial.write(sensor06.ping_cm());
      Serial.write(sensor07.ping_cm());
      Serial.write(sensor08.ping_cm());
      Serial.write(sensor09.ping_cm());
      Serial.write(sensor10.ping_cm());
      Serial.write(sensor11.ping_cm());
      Serial.write(sensor12.ping_cm());
       */
      delay (500)
    ;
}
