 /* CÓDIGO FUNCIONAL */
/* BIBLIOTECAS COMEÇO */
#include <NewPing.h>
/* BIBLIOTECAS FINAL */

#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 200 /* DISTÂNCIA MÁXIMA DE 200 CM */

/* ENTRADA E SAÍDA DE SENSORES */
  NewPing sensor01(23, 22, 200);
  NewPing sensor02(25, 24, 200);
  NewPing sensor03(27, 26, 200);
  NewPing sensor04(29, 28, 200);
  NewPing sensor05(31, 30, 200);
  NewPing sensor06(33, 32, 200);
  NewPing sensor07(35, 34, 200);
  NewPing sensor08(37, 36, 200);
  NewPing sensor09(39, 38, 200);
  NewPing sensor10(41, 40, 200);
  NewPing sensor11(43, 42, 200);
  NewPing sensor12(45, 44, 200);
/* ENTRADA E SAÍDA DE SENSORES FIM */

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.write(sensor01.ping_cm());
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
  delay(500);
}
