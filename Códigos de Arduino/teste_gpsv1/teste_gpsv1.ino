#include<SoftwareSerial.h>
#include<TinyGPS.h>
 
SoftwareSerial SerialGPS(8, 9);
TinyGPS GPS;

float lat, lon, vel;
unsigned long data, hora;
unsigned short sat;
 
void setup() {

  SerialGPS.begin(9600);
  Serial.begin(9600);
 /* Desativar Power Saving Mode */
  SerialGPS.println("AT+CGPSLEEP=0");
  Serial.println("Buscando satelites...");
}

void loop() {
 
  while (SerialGPS.available()) {
    if (GPS.encode(SerialGPS.read())) {
 
      //Hora e data
      GPS.get_datetime(&data, &hora);
      
      Serial.print("--");
      Serial.print((hora / 1000000) - 3);
      Serial.print(":");
      Serial.print((hora % 1000000) / 10000);
      Serial.print(":");
      Serial.print((hora % 10000) / 100);
      Serial.print(" -- ");
 
      Serial.print(data / 10000);
      Serial.print("/");
      Serial.print((data % 10000) / 100);
      Serial.print("/");
      Serial.print(data % 100);
      Serial.println("--");
      
      //latitude e longitude
      GPS.f_get_position(&lat, &lon);
 
      Serial.print("Latitude: ");
      Serial.println(lat, 6);
      Serial.print("Longitude: ");
      Serial.println(lon, 6);
 
      //velocidade
      vel = GPS.f_speed_kmph();
 
      Serial.print("Velocidade: ");
      Serial.println(vel);

      Serial.print("http://maps.google.com/maps?q=");
      Serial.print(lat, 6);
      Serial.print(",");
      Serial.print(lon, 6);

      Serial.println("");
     
 
      //Satelites
      sat = GPS.satellites();
      
 
      if (sat != TinyGPS::GPS_INVALID_SATELLITES) {
        Serial.print("Satelites: ");
        Serial.println(sat);
      }

    Serial.println("");
    }
    else {
      Serial.println("Erro...");
    }
  }
}
