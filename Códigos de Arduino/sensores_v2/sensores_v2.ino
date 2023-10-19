#include <NewPing.h>

#define NUM_SENSORS 2  // Defina o número de sensores que você está usando

NewPing sonar1(23, 22);  // Define os pinos de trigger e echo para o primeiro sensor
NewPing sonar2(25, 24);  // Define os pinos de trigger e echo para o segundo sensor
// Adicione os sensores restantes conforme necessário

const int MIN_DISTANCE_FROM_OBJECT = 15;  // Mínima distância para considerar um obstáculo

void setup() {
  Serial.begin(9600);
}

boolean hasObstacle(NewPing& sensor) {
  int distance = sensor.ping_cm();
  return distance > 0 && distance <= MIN_DISTANCE_FROM_OBJECT;
}

void loop() {
  if (hasObstacle(sonar1) || hasObstacle(sonar2)) {
    Serial.println("Obstacle detected!");
  } else {
    Serial.println("No obstacle detected.");
  }

  delay(1000);  // Ajuste o intervalo de verificação conforme necessário
}
