#define passos_pino 3
#define direcao_pino 6
#define entrada_pino 9


unsigned long valor;


void setup() {
 pinMode(entrada_pino, INPUT);
 pinMode(direcao_pino, OUTPUT);
 pinMode(passos_pino, OUTPUT);
 Serial.begin(9600);
}

void loop() {

  valor = pulseIn(entrada_pino, HIGH);
  Serial.println(valor);
  
  if(valor >= 1600){
  digitalWrite(direcao_pino, LOW);
  digitalWrite(passos_pino, HIGH);
  digitalWrite(passos_pino, LOW);
 }

  if(valor <= 1300){
  digitalWrite(direcao_pino, HIGH);
  digitalWrite(passos_pino, HIGH);
  digitalWrite(passos_pino, LOW);
 }

}
