#include <Wire.h>

// Definindo os pinos dos 12 sensores ultrassônicos
const int trigPins[12] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21};
const int echoPins[12] = {9, 8, 7, 6, 5, 4, 3, 2, 22, 23, 24, 25};

long durations[12];  // Durations dos sensores
long distances[12];  // Distâncias calculadas

// Endereços dos Arduinos dos motores
const int arduinoMotorHorizontal = 8;
const int arduinoMotorVertical = 9;

void setup() {
  // Inicializa a comunicação serial
  Serial.begin(9600);
  Wire.begin();
  
  // Configura os pinos dos sensores
  for (int i = 0; i < 12; i++) {
    pinMode(trigPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
  }

  Serial.println("Iniciando sistema de sensores...");
}

void loop() {
  // Medir a distância de todos os 12 sensores
  for (int i = 0; i < 12; i++) {
    distances[i] = medirDistancia(trigPins[i], echoPins[i]);
    Serial.print("Distância Sensor ");
    Serial.print(i);
    Serial.print(": ");
    Serial.print(distances[i]);
    Serial.println(" cm");
  }

  // Lógica de controle com base nas distâncias
  controleDeMovimento(distances);

  delay(500);  // Atraso de 500ms antes da próxima leitura
}

// Função para medir a distância usando os sensores ultrassônicos
long medirDistancia(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  durations[0] = pulseIn(echoPin, HIGH);
  long distanceCm = (durations[0] * 0.0344) / 2;  // Calcula a distância em cm
  return distanceCm;
}

// Função para controlar o movimento com base nas distâncias dos sensores
void controleDeMovimento(long* distancias) {
  // Distância mínima para detectar um obstáculo
  const long distanciaMinima = 20;

  // Verificar sensores frontais (0, 1, 8, 9)
  if (distancias[0] < distanciaMinima || distancias[1] < distanciaMinima || distancias[8] < distanciaMinima || distancias[9] < distanciaMinima) {
    Serial.println("Obstáculo detectado na frente!");
    parar();
    moverParaTras();
    girarDireita();  // Gira para a direita para evitar o obstáculo
  }
  // Verificar sensores laterais (2 a 7)
  else if (distancias[2] < distanciaMinima || distancias[3] < distanciaMinima || distancias[4] < distanciaMinima || distancias[5] < distanciaMinima || distancias[6] < distanciaMinima || distancias[7] < distanciaMinima) {
    Serial.println("Obstáculo detectado nas laterais!");
    parar();
    moverParaTras();
    girarEsquerda();  // Gira para a esquerda para evitar o obstáculo
  }
  // Verificar se o centro do robô está obstruído (10, 11)
  else if (distancias[10] < distanciaMinima || distancias[11] < distanciaMinima) {
    Serial.println("Obstáculo detectado no centro!");
    parar();
    moverParaTras();
    girarDireita();  // Gira para a direita para evitar o obstáculo
  }
  else {
    // Caso contrário, o robô se move para frente
    Serial.println("Caminho livre, movendo para frente!");
    moverParaFrente();
  }
}

// Função para parar os motores
void parar() {
  Wire.beginTransmission(arduinoMotorHorizontal);
  Wire.write(0);  // Comando para parar motor horizontal
  Wire.endTransmission();

  Wire.beginTransmission(arduinoMotorVertical);
  Wire.write(0);  // Comando para parar motor vertical
  Wire.endTransmission();
}

// Função para mover o robô para trás
void moverParaTras() {
  Wire.beginTransmission(arduinoMotorHorizontal);
  Wire.write(2);  // Comando para mover para trás
  Wire.endTransmission();

  Wire.beginTransmission(arduinoMotorVertical);
  Wire.write(2);  // Comando para mover para trás
  Wire.endTransmission();
}

// Função para girar o robô à esquerda
void girarEsquerda() {
  Wire.beginTransmission(arduinoMotorHorizontal);
  Wire.write(1);  // Comando para girar à esquerda
  Wire.endTransmission();

  Wire.beginTransmission(arduinoMotorVertical);
  Wire.write(1);  // Comando para girar à esquerda
  Wire.endTransmission();
}

// Função para girar o robô à direita
void girarDireita() {
  Wire.beginTransmission(arduinoMotorHorizontal);
  Wire.write(1);  // Comando para girar à direita
  Wire.endTransmission();

  Wire.beginTransmission(arduinoMotorVertical);
  Wire.write(1);  // Comando para girar à direita
  Wire.endTransmission();
}

// Função para mover o robô para frente
void moverParaFrente() {
  Wire.beginTransmission(arduinoMotorHorizontal);
  Wire.write(3);  // Comando para mover para frente
  Wire.endTransmission();

  Wire.beginTransmission(arduinoMotorVertical);
  Wire.write(3);  // Comando para mover para frente
  Wire.endTransmission();
}
