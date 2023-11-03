
 /* CÓDIGO FUNCIONAL */

#include <NewPing.h>
#include <SD.h>

#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 300 /* DISTÂNCIA MÁXIMA DE 200 CM */

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
/* Use as instâncias da classe NewPing para medir as distâncias */
  int distance01 = sensor01.ping_cm();
  int distance02 = sensor02.ping_cm();
  int distance03 = sensor03.ping_cm();
  int distance04 = sensor04.ping_cm();
  int distance05 = sensor05.ping_cm();
  int distance06 = sensor06.ping_cm();
  int distance07 = sensor07.ping_cm();
  int distance08 = sensor08.ping_cm();
  int distance09 = sensor09.ping_cm();
  int distance10 = sensor10.ping_cm();
  int distance11 = sensor11.ping_cm();
  int distance12 = sensor12.ping_cm();

  // Serial.print("A distancia do sensor 01:");
  Serial.write(distance01);
  Serial.write(distance02);
  Serial.write(distance03);
  Serial.write(distance04);
  Serial.write(distance05);
  Serial.write(distance06);
  Serial.write(distance07);
  Serial.write(distance08);
  Serial.write(distance09);
  Serial.write(distance10);
  Serial.write(distance11);
  Serial.write(distance12);
  

  delay(5000);
}
