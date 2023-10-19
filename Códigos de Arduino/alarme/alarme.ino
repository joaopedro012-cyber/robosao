#include <Ultrasonic.h>



#define trigger  5 // Definição do pino digital 5 para o sinal de trigger
#define echo 6 // Definição do pino digital 6 para o sinal echo
 
 
Ultrasonic ultrasonic(trigger, echo); //Inicializa o sensor nos pinos definidos
 
void setup()
{
  Serial.begin(9600);
  Serial.println("Começando a leitura de dados do sensor...");
}
 
void loop()
{
  //Leitura de informações do sensor em cm
  float cmMsec;
  long microsec = ultrasonic.timing();
  cmMsec = ultrasonic.convert(microsec, Ultrasonic::CM);
  Serial.print("Distância em cm: ");
  Serial.print(cmMsec);
  delay(1000);
}
