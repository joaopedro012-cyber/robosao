
 /* CÓDIGO FUNCIONAL */

#include <NewPing.h>
#include <SD.h>

#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 300 /* DISTÂNCIA MÁXIMA DE 200 CM */

/* DECLARAÇÃO DE CONSTANTES COMEÇO */
  #define echo_sensor01  44
  #define trigger_sensor01  45
  #define echo_sensor02  22
  #define trigger_sensor02  23
  #define echo_sensor03  24
  #define trigger_sensor03  25
  #define echo_sensor04  26
  #define trigger_sensor04  27
  #define echo_sensor05  28
  #define trigger_sensor05  29
  #define echo_sensor06  30
  #define trigger_sensor06  31
  #define echo_sensor07  32
  #define trigger_sensor07  33
  #define echo_sensor08  34
  #define trigger_sensor08  35
  #define echo_sensor09  36
  #define trigger_sensor09  37
  #define echo_sensor10  38
  #define trigger_sensor10  39
  #define echo_sensor11  40
  #define trigger_sensor11  41
  #define echo_sensor12  42
  #define trigger_sensor12  43
/* DECLARAÇÃO DE CONSTANTES COMEÇO */

/* ENTRADA E SAÍDA DE SENSORES */
  NewPing sensor01(trigger_sensor01, echo_sensor01, 200);
  NewPing sensor02(trigger_sensor02, echo_sensor02, 200);
  NewPing sensor03(trigger_sensor03, echo_sensor03, 200);
  NewPing sensor04(trigger_sensor04, echo_sensor04, 200);
  NewPing sensor05(trigger_sensor05, echo_sensor05, 200);
  NewPing sensor06(trigger_sensor06, echo_sensor06, 200);
  NewPing sensor07(trigger_sensor07, echo_sensor07, 200);
  NewPing sensor08(trigger_sensor08, echo_sensor08, 200);
  NewPing sensor09(trigger_sensor09, echo_sensor09, 200);
  NewPing sensor10(trigger_sensor10, echo_sensor10, 200);
  NewPing sensor11(trigger_sensor11, echo_sensor11, 200);
  NewPing sensor12(trigger_sensor12, echo_sensor12, 200);
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

  Serial.print("A distancia do sensor 01:");
  Serial.println(distance01);
  Serial.print("A distancia do sensor 02:");
  Serial.println(distance02);
  Serial.print("A distancia do sensor 03:");
  Serial.println(distance03);
  Serial.print("A distancia do sensor 04:");
  Serial.println(distance04);
  Serial.print("A distancia do sensor 05:");
  Serial.println(distance05);
  Serial.print("A distancia do sensor 06:");
  Serial.println(distance06);
  Serial.print("A distancia do sensor 07:");
  Serial.println(distance07);
  Serial.print("A distancia do sensor 08:");
  Serial.println(distance08);
  Serial.print("A distancia do sensor 09:");
  Serial.println(distance09);
  Serial.print("A distancia do sensor 10:");
  Serial.println(distance10);
  Serial.print("A distancia do sensor 11:");
  Serial.println(distance11);
  Serial.print("A distancia do sensor 12:");
  Serial.println(distance12);
  delay(10000);
}
