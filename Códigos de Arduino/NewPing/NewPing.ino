#include <NewPing.h>
 
#define SONAR_NUM     9 // Numero de sensores.
#define MAX_DISTANCE 200 // Distancia maxima em cm.
#define PING_INTERVAL 33 // Millisegundos entre pings.
 
unsigned long pingTimer[SONAR_NUM]; // Quando cada pings.
unsigned int cm[SONAR_NUM]; // Armazena distâncias do ping.
uint8_t currentSensor = 0; // Que sensor é ativo.
 
NewPing sonar[SONAR_NUM] = { // Declaração dos pins de cada sensor.
  NewPing(22, 23, MAX_DISTANCE),
  NewPing(26, 27, MAX_DISTANCE),
  NewPing(30, 31, MAX_DISTANCE),
  NewPing(34, 35, MAX_DISTANCE),
  NewPing(38, 39, MAX_DISTANCE),
  NewPing(42, 43, MAX_DISTANCE),
  NewPing(46, 47, MAX_DISTANCE),
  NewPing(50, 51, MAX_DISTANCE),

};
 
void setup() {
  Serial.begin(115200);
  pingTimer[0] = millis() + 75; // O primeiro ping é iniciado em ms.
  for (uint8_t i = 1; i < SONAR_NUM; i++)
    pingTimer[i] = pingTimer[i - 1] + PING_INTERVAL;
}
 
void loop() {
  for (uint8_t i = 0; i < SONAR_NUM; i++) {
    if (millis() >= pingTimer[i]) {
      pingTimer[i] += PING_INTERVAL * SONAR_NUM;
      if (i == 0 && currentSensor == SONAR_NUM - 1)
        oneSensorCycle(); // Faz alguma coisa com os resultados.
        sonar[currentSensor].timer_stop();
        currentSensor = i;
        cm[currentSensor] = 0;
        sonar[currentSensor].ping_timer(echoCheck);
    }
  }
  // O resto do seu código será colocado aqui.
}
 
void echoCheck() { //Se existir um ping o valor será registado no array
  if (sonar[currentSensor].check_timer())
    cm[currentSensor] = sonar[currentSensor].ping_result / US_ROUNDTRIP_CM;
}
 
void oneSensorCycle() { // Faz alguma coisa com os resultados.
  for (uint8_t i = 0; i < SONAR_NUM; i++) {
    Serial.print(i);
    Serial.print("=");
    Serial.print(cm[i]);
    Serial.print("cm ");
  }
  Serial.println();
}
