#include <NewPing.h>
#define SONAR_NUM 12 /* NÚMERO DE SENSORES */
#define MAX_DISTANCE 200 /* DISTÂNCIA MÁXIMA DE 200 CM */

const byte echo_sensor01 = 20;
const byte triger_sensor01 = 21;
const byte echo_sensor02 = 22;
const byte triger_sensor02 = 23;
const byte echo_sensor03 = 24;
const byte triger_sensor03 = 25;
const byte echo_sensor04 = 26;
const byte triger_sensor04 = 27;
const byte echo_sensor05 = 28;
const byte triger_sensor05 = 29;
const byte echo_sensor06 = 30;
const byte triger_sensor06 = 31;
const byte echo_sensor07 = 32;
const byte triger_sensor07 = 33;
const byte echo_sensor08 = 34;
const byte triger_sensor08 = 35;
const byte echo_sensor09 = 36;
const byte triger_sensor09 = 37;
const byte echo_sensor10 = 38;
const byte triger_sensor10 = 39;
const byte echo_sensor11 = 40;
const byte triger_sensor11 = 41;
const byte echo_sensor12 = 42;
const byte triger_sensor12 = 43;


/* Armazena a quantidade de vezes que a medição deve ocorrer, para cada sensor */
unsigned long pingTimer[SONAR_NUM]; 

/* Armazena o número de medições */
unsigned int cm[SONAR_NUM]; 
