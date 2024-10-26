void setup() {
  // Inicializa a comunicação serial a 9600 bps
  Serial.begin(9600);
}

void loop() {
  // Verifica se há dados disponíveis na porta serial
  if (Serial.available() > 0) {
    // Lê os dados recebidos
    String received = Serial.readStringUntil('\n');
    
    // Verifica se o dado recebido é "ola"
    if (received == "ola") {
      // Envia a resposta "teste recebido"
      Serial.println("teste recebido");
    }
  }
}
