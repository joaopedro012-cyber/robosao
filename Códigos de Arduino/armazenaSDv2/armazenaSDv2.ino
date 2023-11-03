void setup() {
  Serial1.begin(4800);

}

void loop() {
  if(Serial1.available()>0) {
    String c = Serial1.read();
    Serial1.println(c);
  }
}
