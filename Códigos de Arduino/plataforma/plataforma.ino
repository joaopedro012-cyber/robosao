const int relePin = 7; // Pino digital conectado ao módulo relé

void setup() {
  pinMode(relePin, OUTPUT); // Define o pino do relé como saída
  Serial.begin(9600); // Inicia a comunicação serial
  digitalWrite(relePin, LOW); // Inicialmente, desliga o relé
}

void loop() {
  if (Serial.available() > 0) {
    char comando = Serial.read(); // Lê o comando recebido via serial

    if (comando == 'M') {
      digitalWrite(relePin, HIGH); // Liga o relé
      Serial.println("Relé ligado");
    } else if (comando == 'N') {
      digitalWrite(relePin, LOW); // Desliga o relé
      Serial.println("Relé desligado");
    }
  }
}
