/* RC CAR, Translated from Bluetooth Amazon Car to work with Arduino Mega, Flysky FS-I6X Controller and Receiver and Adafruit Motor Shield v2.3

Special thanks to Youtube Channel "DroneBot Workshop" for providing a Template for the Code - https://dronebotworkshop.com/radio-control-arduino-car/
Channel functions by Ricardo Paiva - https://gist.github.com/werneckpaiva/

Written by Enrique Lopez - reference "https://enriquelopezcode.github.io/projects/rc_car" and click on the Arduino Projects Hub link for required parts and wiring  */

//Include Libraries
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"
#include <IBusBM.h>
#define passos_pino 3
#define direcao_pino 6
#define entrada_pino 9
const int echoPin = 5;
const int trigPin = 4;
float distancia;
String result; 
unsigned long valor;

//Initialize Motors
Adafruit_MotorShield AFMS = Adafruit_MotorShield();
Adafruit_DCMotor *motor1 = AFMS.getMotor(1);
Adafruit_DCMotor *motor2 = AFMS.getMotor(2);
Adafruit_DCMotor *motor3 = AFMS.getMotor(3);
Adafruit_DCMotor *motor4 = AFMS.getMotor(4);


// Create iBus Object and Channel Values
IBusBM ibus;

int rcCH1 = 0;  // Acceleration
int rcCH2 = 0;  // Left - Right
int rcCH3 = 0;  // Forward - Backward

//Motor Speed Variables
int motor1speed = 0;
int motor2speed = 0;
int motor3speed = 0;
int motor4speed = 0;

//Motor Direction variables
int motor1dir = 0;
int motor2dir = 0;
int motor3dir = 0;
int motor4dir = 0;

// Read the number of a given channel and convert to the range provided.
// If the channel is off, return the default value (by Ricardo Paiva)
int readChannel(byte channelInput, int minLimit, int maxLimit, int defaultValue) {
  uint16_t ch = ibus.readChannel(channelInput);
  if (ch < 100) return defaultValue;
  return map(ch, 1000, 2000, minLimit, maxLimit);
}


// Control Motor
void mControl1(int mspeed, int mdir) {
  motor1->setSpeed(mspeed);
  if (mdir == 1) {
    motor1->run(FORWARD);
  } else {
    motor1->run(BACKWARD);
  }
}

void mControl2(int mspeed, int mdir) {
  motor2->setSpeed(mspeed);
  if (mdir == 1) {
    motor2->run(FORWARD);
  } else {
    motor2->run(BACKWARD);
  }
}

void mControl3(int mspeed, int mdir) {
  motor3->setSpeed(mspeed);
  if (mdir == 1) {
    motor3->run(FORWARD);
  } else {
    motor3->run(BACKWARD);
  }
}

void mControl4(int mspeed, int mdir) {
  motor4->setSpeed(mspeed);
  if (mdir == 1) {
    motor4->run(FORWARD);
  } else {
    motor4->run(BACKWARD);
  }
}







void setup() {
  //Call begin on Motorshield Object and Delay for Connection
  AFMS.begin();
  ibus.begin(Serial);
  delay(2000);
  
  
}

void loop() {
  //Get Channel Values
  rcCH1 = readChannel(0, -100, 100, 0);
  rcCH2 = readChannel(1, -100, 100, 0);
  rcCH3 = readChannel(2, 0, 155, 0);

  //Motor Speeds Channel 3
  motor1speed = rcCH3;
  motor2speed = rcCH3;
  motor3speed = rcCH3;
  motor4speed = rcCH3;

  //Forward and Backward with Channel 2 Value
  if (rcCH2 >= 0) {
    //Forward
    motor1dir = 1;
    motor2dir = 1;
    motor3dir = 1;
    motor4dir = 1;
  } else {
    //Backward
    motor1dir = -1;
    motor2dir = -1;
    motor3dir = -1;
    motor4dir = -1;
  }

  //Add Channel 2 Speed
  motor1speed = motor1speed + abs(rcCH2);
  motor2speed = motor2speed + abs(rcCH2);
  motor3speed = motor3speed + abs(rcCH2);
  motor4speed = motor4speed + abs(rcCH2);

  // Set left/right offset with channel 1 value
  motor1speed = motor1speed + rcCH1;
  motor2speed = motor2speed + rcCH1;
  motor3speed = motor3speed - rcCH1;
  motor4speed = motor4speed - rcCH1;

  // Ensure that speeds are between 0 and 255
  motor1speed = constrain(motor1speed, 0, 255);
  motor2speed = constrain(motor2speed, 0, 255);
  motor3speed = constrain(motor3speed, 0, 255);
  motor4speed = constrain(motor4speed, 0, 255);

  //Drive Motors

  mControl1(motor1speed, motor1dir);
  mControl2(motor2speed, motor2dir);
  mControl3(motor3speed, motor3dir);
  mControl4(motor4speed, motor4dir);

  //small delay
  delay(50);
}
