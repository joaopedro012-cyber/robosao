void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  if (Serial1.available()) {
    char recebido = Serial1.read();
    Serial.print("Recebido: ");
    Serial.println(recebido);
  }
}
