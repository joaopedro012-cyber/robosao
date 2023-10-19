#define passos_pino 3
#define direcao_pino 6

int passos = 600;


void setup() {
 pinMode(direcao_pino, OUTPUT);
 pinMode(passos_pino, OUTPUT);
 digitalWrite(direcao_pino, HIGH);
}

void loop() {

 while( passos >= 0){
  digitalWrite(passos_pino, HIGH);
  digitalWrite(passos_pino, LOW);
  delay(5);
 }

}
