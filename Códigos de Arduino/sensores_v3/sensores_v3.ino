#include <NewPing.h>
#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 200 /* DISTÂNCIA MÁXIMA DE 200 CM */

/* DECLARAÇÃO DE CONSTANTES COMEÇO */
  const byte echo_sensor01 = 20;
  const byte trigger_sensor01 = 21;
  const byte echo_sensor02 = 22;
  const byte trigger_sensor02 = 23;
  const byte echo_sensor03 = 24;
  const byte trigger_sensor03 = 25;
  const byte echo_sensor04 = 26;
  const byte trigger_sensor04 = 27;
  const byte echo_sensor05 = 28;
  const byte trigger_sensor05 = 29;
  const byte echo_sensor06 = 30;
  const byte trigger_sensor06 = 31;
  const byte echo_sensor07 = 32;
  const byte trigger_sensor07 = 33;
  const byte echo_sensor08 = 34;
  const byte trigger_sensor08 = 35;
  const byte echo_sensor09 = 36;
  const byte trigger_sensor09 = 37;
  const byte echo_sensor10 = 38;
  const byte trigger_sensor10 = 39;
  const byte echo_sensor11 = 40;
  const byte trigger_sensor11 = 41;
  const byte echo_sensor12 = 42;
  const byte trigger_sensor12 = 43;
/* DECLARAÇÃO DE CONSTANTES COMEÇO */

/* ENTRADA E SAÍDA DE SENSORES */
  NewPing sensor01(trigger_sensor01, echo_sensor01);
  NewPing sensor02(trigger_sensor02, echo_sensor02);
  NewPing sensor03(trigger_sensor03, echo_sensor03);
  NewPing sensor04(trigger_sensor04, echo_sensor04);
  NewPing sensor05(trigger_sensor05, echo_sensor05);
  NewPing sensor06(trigger_sensor06, echo_sensor06);
  NewPing sensor07(trigger_sensor07, echo_sensor07);
  NewPing sensor08(trigger_sensor08, echo_sensor08);
  NewPing sensor09(trigger_sensor09, echo_sensor09);
  NewPing sensor10(trigger_sensor10, echo_sensor10);
  NewPing sensor11(trigger_sensor11, echo_sensor11);
  NewPing sensor12(trigger_sensor12, echo_sensor12);
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

  Serial.println("distance01");
  Serial.println(sensor12.ping_cm());
  Serial.println("distance02");
  Serial.println(distance02);
  Serial.println("distance03");
  Serial.println(distance03);
  Serial.println("distance04");
  Serial.println(distance04);
  Serial.println("distance05");
  Serial.println(distance05);
  Serial.println("distance06");
  Serial.println(distance06);
  Serial.println("distance07");
  Serial.println(distance07);
  Serial.println("distance08");
  Serial.println(distance08);
  Serial.println("distance09");
  Serial.println(distance09);
  Serial.println("distance10");
  Serial.println(distance10);
  Serial.println("distance11");
  Serial.println(distance11);
  Serial.println("distance12");
  Serial.println(distance12);
  delay(10000);
}
