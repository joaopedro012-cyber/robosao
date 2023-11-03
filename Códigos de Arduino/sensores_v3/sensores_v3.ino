
 /* CÓDIGO FUNCIONAL */

#include <NewPing.h>
#include <SD.h>

#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 300 /* DISTÂNCIA MÁXIMA DE 200 CM */

/* DECLARAÇÃO DE CONSTANTES COMEÇO */
  #define echo_sensor01  22
  #define trigger_sensor01  23
  #define echo_sensor02  24
  #define trigger_sensor02  25
  #define echo_sensor03  26
  #define trigger_sensor03  27
  #define echo_sensor04  28
  #define trigger_sensor04  29
  #define echo_sensor05  30
  #define trigger_sensor05  31
  #define echo_sensor06  32
  #define trigger_sensor06  33
  #define echo_sensor07  34
  #define trigger_sensor07  35
  #define echo_sensor08  36
  #define trigger_sensor08  37
  #define echo_sensor09  38
  #define trigger_sensor09  39
  #define echo_sensor10  40
  #define trigger_sensor10  41
  #define echo_sensor11  42
  #define trigger_sensor11  43
  #define echo_sensor12  44
  #define trigger_sensor12  45
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
