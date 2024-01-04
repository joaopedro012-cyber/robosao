#include <Arduino.h>
const byte led = 13;

void setup() {
  Serial.begin(4800);
  pinMode(led,OUTPUT);
  digitalWrite(led,LOW);

}

void loop() {
  if(Serial.available()>0) {
    char c=Serial.read();
    Serial.println(c);
    if(c =='A') {
      digitalWrite(led,HIGH);
     } 
     if(c=='a'){
        digitalWrite(led,LOW);
      }
}
}