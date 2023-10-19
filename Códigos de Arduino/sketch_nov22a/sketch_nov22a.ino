#include <Ultrasonic.h>

#define passos_pino 3
#define direcao_pino 6
#define entrada_pino 9
const int echoPin = 5;
const int trigPin = 4;
float distancia;
String result; 
Ultrasonic ultrasonic(trigPin,echoPin);
unsigned long valor;


void setup() {
 pinMode(entrada_pino, INPUT);
 pinMode(direcao_pino, OUTPUT);
 pinMode(passos_pino, OUTPUT);
 pinMode(echoPin, INPUT); 
 pinMode(trigPin, OUTPUT);
 Serial.begin(9600);
}

void loop() {

  valor = pulseIn(entrada_pino, HIGH);
  Serial.println(valor);

  if(valor >= 1600){
  digitalWrite(direcao_pino, LOW);
  digitalWrite(passos_pino, HIGH);
  digitalWrite(passos_pino, LOW);
 }

  if(valor <= 1400){
  digitalWrite(direcao_pino, HIGH);
  digitalWrite(passos_pino, HIGH);
  digitalWrite(passos_pino, LOW);
 }


  if (distancia < 20){
    digitalWrite(passos_pino, LOW);
    digitalWrite(passos_pino, LOW);
    digitalWrite(entrada_pino, LOW);
  }

    else {
    digitalWrite(passos_pino, HIGH);
    digitalWrite(passos_pino, HIGH);
    digitalWrite(entrada_pino, HIGH);
  }

  
  hcsr04(); // FAZ A CHAMADA DO MÉTODO "hcsr04()"
  Serial.println("Distancia "); //IMPRIME O TEXTO NO MONITOR SERIAL
  Serial.println(result); ////IMPRIME NO MONITOR SERIAL A DISTÂNCIA MEDIDA
  Serial.println("cm"); //IMPRIME O TEXTO NO MONITOR SERIAL


  
}

void hcsr04(){
    digitalWrite(trigPin, LOW); //SETA O PINO 6 COM UM PULSO BAIXO "LOW"
    delayMicroseconds(2); //INTERVALO DE 2 MICROSSEGUNDOS
    digitalWrite(trigPin, HIGH); //SETA O PINO 6 COM PULSO ALTO "HIGH"
    delayMicroseconds(10); //INTERVALO DE 10 MICROSSEGUNDOS
    digitalWrite(trigPin, LOW); //SETA O PINO 6 COM PULSO BAIXO "LOW" NOVAMENTE
    //FUNÇÃO RANGING, FAZ A CONVERSÃO DO TEMPO DE
    //RESPOSTA DO ECHO EM CENTIMETROS, E ARMAZENA
    //NA VARIAVEL "distancia"
    distancia = (ultrasonic.Ranging(CM)); //VARIÁVEL GLOBAL RECEBE O VALOR DA DISTÂNCIA MEDIDA
    result = String(distancia); //VARIÁVEL GLOBAL DO TIPO STRING RECEBE A DISTÂNCIA(CONVERTIDO DE INTEIRO PARA STRING)
    delay(500); //INTERVALO DE 500 MILISSEGUNDOS
 }
 
