/* BIBLIOTECAS COMEÇO */
#include <Arduino.h>
#include <NewPing.h>
#include <stdio.h>
/* BIBLIOTECAS FINAL */

#define SONAR_NUM 12     /* NÚMERO DE SENSORES ULTRASSOM */
#define MAX_DISTANCE 200 /* DISTÂNCIA MÁXIMA DE 200 CM NOS SENSORES DE ULTRASSOM */

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
}

void sensorUltrassom(int portaSensorUltrassom)
{
}

void sensorFisico(int portaSensorFisico)
{
  pinMode(portaSensorFisico, INPUT_PULLUP);
  char str[10]; // Aumente o tamanho conforme necessário
  int sensorValue = digitalRead(portaSensorFisico);

  if (sensorValue == HIGH)
  {
    snprintf(str, sizeof(str), "b%d", portaSensorFisico);
  }
  else
  {
    snprintf(str, sizeof(str), "A%d", portaSensorFisico);
  }

  Serial.println(str);
}

void loop()
{
  if (Serial.available() > 0)
  {
    String input = Serial.readStringUntil('\n');

    if (input == "identify")
    {
      Serial.println("sensor_fisico_ultrassom");
    }
  }
  sensorFisico(2);
  sensorFisico(3);
  sensorFisico(4);
  sensorFisico(5);
  sensorFisico(6);
  sensorFisico(7);
  sensorFisico(8);
  sensorFisico(9);
  Serial.print("S01:");
  Serial.println(sensor01.ping_cm());
  Serial.print("S02:");
  Serial.println(sensor02.ping_cm());
  Serial.print("S03:");
  Serial.println(sensor03.ping_cm());
  Serial.print("S04:");
  Serial.println(sensor04.ping_cm());
  Serial.print("S05:");
  Serial.println(sensor05.ping_cm());
  Serial.print("S06:");
  Serial.println(sensor06.ping_cm());
  Serial.print("S07:");
  Serial.println(sensor07.ping_cm());
  Serial.print("S08:");
  Serial.println(sensor08.ping_cm());
  Serial.print("S09:");
  Serial.println(sensor09.ping_cm());
  Serial.print("S10:");
  Serial.println(sensor10.ping_cm());
  Serial.print("S11:");
  Serial.println(sensor11.ping_cm());
  Serial.print("S12:");
  Serial.println(sensor12.ping_cm());

  delay(900);
}
