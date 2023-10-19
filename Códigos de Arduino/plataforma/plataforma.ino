// Inclui a Biblioteca AccelStepper
#include <AccelStepper.h>
 
// Define os pinos de conexão
const int DIR = 2;
const int STEP = 3;
 
// Defina o tipo de interface do motor
#define InterfaceMotor 1
 
// Cria uma instância
AccelStepper Stepper(InterfaceMotor, STEP, DIR);
 
void setup() {
  // Define a velocidade máxima, fator de aceleração,
  // velocidade inicial e a posição desejada
  Stepper.setMaxSpeed(1000);   // Velocidade máxima
  Stepper.setAcceleration(50);   // Aceleração
  Stepper.setSpeed(200);   // Velocidade regular
  Stepper.moveTo(200);    // Passos que serão movidos
}
 
void loop() {
  // Muda a direção assim que o motor atingir a posição desejada
  if (Stepper.distanceToGo() == 0)
    Stepper.moveTo(-Stepper.currentPosition());
 
  // Mova o motor um passo
  Stepper.run();
}
