
/*
COM 4 -- SENSORES
COM 3 -- SD CARD
*/
#include <NewPing.h> /* INCLUI BIBLIOTECA DOS SENSORES */

void setup() {
Serial1.begin(4800); // Inicia a comunicação serial no pino 19 (RX) e 18 (TX)  
}

#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 300 /* DISTÂNCIA MÁXIMA DE 300 CM */

/* ENTRADA E SAÍDA DE SENSORES */
NewPing sensor01(45, 44, 200);
NewPing sensor02(23, 22, 200);
NewPing sensor03(25, 24, 200);
NewPing sensor04(27, 26, 200);
NewPing sensor05(29, 28, 200);
NewPing sensor06(31, 30, 200);
NewPing sensor07(33, 32, 200);
NewPing sensor08(35, 34, 200);
NewPing sensor09(37, 36, 200);
NewPing sensor10(39, 38, 200);
NewPing sensor11(41, 40, 200);
NewPing sensor12(43, 42, 200);
/* ENTRADA E SAÍDA DE SENSORES FIM */



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
  
  Serial1.println(distance01);
}
