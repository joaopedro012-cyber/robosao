#include <Arduino.h>
#include <SoftwareSerial.h>

// Pinos do Bluetooth HC-05 (RX no pino 2, TX no pino 3)
SoftwareSerial bluetooth(2, 3); // RX, TX

// Definições dos pinos para os 3 motores horizontais
const int pulsePin1 = 12;   // Pino de Pulso Motor 1
const int dirPin1 = 4;      // Pino de Direção Motor 1
const int enablePin1 = 13;  // Pino de Enable Motor 1

const int pulsePin2 = 9;    // Pino de Pulso Motor 2
const int dirPin2 = 10;     // Pino de Direção Motor 2
const int enablePin2 = 8;   // Pino de Enable Motor 2

const int pulsePin3 = 6;    // Pino de Pulso Motor 3
const int dirPin3 = 5;      // Pino de Direção Motor 3
const int enablePin3 = 7;   // Pino de Enable Motor 3

const int numPulses = 6400;  // Número de pulsos para cada motor horizontal
const int pulseDelay = 20;   // Tempo de delay entre os pulsos (em microssegundos)

void setup() {
  // Configuração dos pinos como saída
  pinMode(pulsePin1, OUTPUT);
  pinMode(dirPin1, OUTPUT);
  pinMode(enablePin1, OUTPUT);

  pinMode(pulsePin2, OUTPUT);
  pinMode(dirPin2, OUTPUT);
  pinMode(enablePin2, OUTPUT);

  pinMode(pulsePin3, OUTPUT);
  pinMode(dirPin3, OUTPUT);
  pinMode(enablePin3, OUTPUT);

  // Ativar motores
  digitalWrite(enablePin1, LOW); // LOW ativa os motores
  digitalWrite(enablePin2, LOW);
  digitalWrite(enablePin3, LOW);

  Serial.begin(9600);       // Comunicação Serial com o computador
  bluetooth.begin(9600);    // Comunicação Serial com o módulo Bluetooth

  Serial.println("Aguardando comando via Bluetooth...");
}

void loop() {
  if (bluetooth.available() > 0) {  // Verifica se há dados recebidos pelo Bluetooth
    char command = bluetooth.read(); // Lê o comando recebido

    switch (command) {
      case 'w':
        Serial.println("Comando recebido: W (Frente)");
        bluetooth.println("Comando recebido: W (Frente)"); // Envia feedback via Bluetooth
        moveMotor(1, true);  // Movimenta motor 1 para frente
        moveMotor(2, true);  // Movimenta motor 2 para frente
        moveMotor(3, true);  // Movimenta motor 3 para frente
        break;
      case 'x':
        Serial.println("Comando recebido: X (Trás)");
        bluetooth.println("Comando recebido: X (Trás)"); // Envia feedback via Bluetooth
        moveMotor(1, false); // Movimenta motor 1 para trás
        moveMotor(2, false); // Movimenta motor 2 para trás
        moveMotor(3, false); // Movimenta motor 3 para trás
        break;
      case 's':
        Serial.println("Comando recebido: S (Parar)");
        bluetooth.println("Comando recebido: S (Parar)"); // Envia feedback via Bluetooth
        stopMotors();  // Função para parar os motores
        break;
      default:
        Serial.println("Comando inválido. Use 'W' para frente, 'X' para trás ou 'S' para parar.");
        bluetooth.println("Comando inválido. Use 'W' para frente, 'X' para trás ou 'S' para parar.");
        break;
    }
  }
}

void moveMotor(int motor, bool forward) {
  int pulsePin, dirPin;

  // Determina os pinos de pulso e direção de acordo com o motor
  if (motor == 1) {
    pulsePin = pulsePin1;
    dirPin = dirPin1;
  } else if (motor == 2) {
    pulsePin = pulsePin2;
    dirPin = dirPin2;
  } else if (motor == 3) {
    pulsePin = pulsePin3;
    dirPin = dirPin3;
  }

  // Define a direção do motor
  digitalWrite(dirPin, forward ? HIGH : LOW);

  // Envia 6400 pulsos para o motor especificado
  for (int i = 0; i < numPulses; i++) {
    digitalWrite(pulsePin, HIGH);
    delayMicroseconds(pulseDelay);
    digitalWrite(pulsePin, LOW);
    delayMicroseconds(pulseDelay);
  }
}

void stopMotors() {
  // Para todos os motores desativando seus pinos de pulso
  digitalWrite(pulsePin1, LOW);
  digitalWrite(pulsePin2, LOW);
  digitalWrite(pulsePin3, LOW);

  // Desativar os pinos enable para todos os motores
  digitalWrite(enablePin1, HIGH); // HIGH desativa
  digitalWrite(enablePin2, HIGH); 
  digitalWrite(enablePin3, HIGH); 

  Serial.println("Motores parados.");
  bluetooth.println("Motores parados.");
}
