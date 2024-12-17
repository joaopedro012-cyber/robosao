#include <Arduino.h>

const int sensorPin = 7;  // Pino do sensor de obstáculos (ex: sensor de proximidade)
const int motorPin = 9;   // Pino do motor ou outro dispositivo (ex: motor)

String comandoRecebido = "";  // Variável para armazenar o comando recebido

// Função para executar a rotina com base nos dados JSON
void executarRotina(String rotinaJson) {
  // Simulando a execução da rotina conforme os dados do JSON
  // Aqui o Arduino interpretaria o JSON e realizaria ações com base nos dados

  // Ativa o motor, por exemplo, se o comando 'ativo' for verdadeiro
  if (rotinaJson.indexOf("motor") >= 0) {  // Verifica se há motor no JSON
    digitalWrite(motorPin, HIGH);  // Liga o motor
    delay(2000);  // Aguarda 2 segundos

    // Verifica se o sensor de obstáculos detectou algo
    if (digitalRead(sensorPin) == HIGH) {
      Serial.println("obstaculo_detectado");  // Envia a mensagem ao Flutter
      digitalWrite(motorPin, LOW);  // Desliga o motor
    } else {
      Serial.println("Rotina executada com sucesso!");
    }

    digitalWrite(motorPin, LOW);  // Desliga o motor no final
  }
}

void setup() {
  Serial.begin(9600);  // Inicia a comunicação serial a 9600 bps
  pinMode(sensorPin, INPUT);  // Definir o pino do sensor como entrada
  pinMode(motorPin, OUTPUT);  // Definir o pino do motor como saída
}

void loop() {
  // Verifica se há dados disponíveis na porta serial
  if (Serial.available() > 0) {
    // Lê a string recebida
    comandoRecebido = Serial.readString();
    comandoRecebido.trim();  // Remove espaços em branco ou quebras de linha

    // Verifica se o comando recebido é 'start_routine'
    if (comandoRecebido == "start_routine") {
      Serial.println("Iniciando a rotina...");

      // Simulação de execução da rotina com base no JSON recebido
      // Aqui você pode adicionar lógica para processar o JSON conforme necessário
      String rotinaJson = "{\"sensores\": [{\"nome\": \"sensor_obstaculo\", \"diretorio\": \"7\", \"distancia_minima\": 10}], \"automacao\": [{\"nome\": \"motor\", \"porta\": \"9\", \"ativo\": true}]}";
      
      // Chama a função para executar a rotina com o JSON
      executarRotina(rotinaJson);
    }
  }
}
