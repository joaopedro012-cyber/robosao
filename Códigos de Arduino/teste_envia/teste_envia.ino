void setup() {
  Serial.begin(4800);

}

void loop() {
  Serial.write('A');
  delay(2000);
  Serial.write('a');
  delay(2000);
}
