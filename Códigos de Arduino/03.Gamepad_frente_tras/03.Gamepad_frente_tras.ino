/*
   Gamepad module provides three different mode namely Digital, JoyStick and Accerleometer.

   You can reduce the size of library compiled by enabling only those modules that you want to
   use. For this first define CUSTOM_SETTINGS followed by defining INCLUDE_modulename.

   Explore more on: https://thestempedia.com/docs/dabble/game-pad-module/
*/
#define CUSTOM_SETTINGS
#define INCLUDE_GAMEPAD_MODULE
#define IN1 9
#define IN2 10    
#define IN3 6
#define IN4 11
#include <Dabble.h>


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);      // make sure your Serial Monitor is also set at this baud rate.
  Dabble.begin(9600);       //Enter baudrate of your bluetooth.Connect bluetooth on Bluetooth port present on evive.
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(11, OUTPUT);
}

void loop() {
  Dabble.processInput();             //this function is used to refresh data obtained from smartphone.Hence calling this function is mandatory in order to get data properly from your mobile.
  Serial.print("KeyPressed: ");
  if (GamePad.isUpPressed())
  {
    Serial.print("UP"); 
      analogWrite(9,HIGH);
      analogWrite(10,LOW);
  } else {
      analogWrite(9,LOW);
  }
   
  if (GamePad.isDownPressed())
  {
    Serial.print("DOWN");
      analogWrite(9,HIGH);
      analogWrite(10,HIGH);
  } else {
      analogWrite(9,LOW);
      analogWrite(10,LOW);
  }

  if (GamePad.isLeftPressed())
  {
     Serial.print("Left");
     analogWrite(11,HIGH);
     analogWrite(6,LOW);
  } else {
    analogWrite(11,LOW);
    Serial.print("Left");
  }

  if (GamePad.isRightPressed())
  {
    Serial.print("Right");
    analogWrite(11,HIGH);
    analogWrite(6,HIGH);
  } else {
    analogWrite(11,LOW);
    analogWrite(6,LOW);
    Serial.print("Right");
  }

  if (GamePad.isSquarePressed())
  {
    Serial.print("Square");
  }

  if (GamePad.isCirclePressed())
  {
    Serial.print("Circle");
  }

  if (GamePad.isCrossPressed())
  {
    Serial.print("Cross");
  }

  if (GamePad.isTrianglePressed())
  {
    Serial.print("Triangle");
  }

  if (GamePad.isStartPressed())
  {
    Serial.print("Start");
  }

  if (GamePad.isSelectPressed())
  {
    Serial.print("Select");
  }
  Serial.print('\t');

  int a = GamePad.getAngle();
  Serial.print("Angle: ");
  Serial.print(a);
  Serial.print('\t');
  int b = GamePad.getRadius();
  Serial.print("Radius: ");
  Serial.print(b);
  Serial.print('\t');
  float c = GamePad.getXaxisData();
  Serial.print("x_axis: ");
  Serial.print(c);
  Serial.print('\t');
  float d = GamePad.getYaxisData();
  Serial.print("y_axis: ");
  Serial.println(d);
  Serial.println();
}
