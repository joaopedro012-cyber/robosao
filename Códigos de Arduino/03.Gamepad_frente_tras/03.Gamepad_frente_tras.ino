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
#include <SoftwareSerial.h>

SoftwareSerial serial1(3, 5); /* RX, TX */

void setup() {
  // put your setup code here, to run once:
  serial1.begin(115200);      // make sure your serial1 Monitor is also set at this baud rate.
  Dabble.begin(9600);       //Enter baudrate of your bluetooth.Connect bluetooth on Bluetooth port present on evive.
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(11, OUTPUT);
}

void loop() {
  Dabble.processInput();             //this function is used to refresh data obtained from smartphone.Hence calling this function is mandatory in order to get data properly from your mobile.
  serial1.print("KeyPressed: ");
  if (GamePad.isUpPressed())
  {
    serial1.print("UP"); 
      analogWrite(9,HIGH);
      analogWrite(10,LOW);
  } else {
      analogWrite(9,LOW);
  }
   
  if (GamePad.isDownPressed())
  {
    serial1.print("DOWN");
      analogWrite(9,HIGH);
      analogWrite(10,HIGH);
  } else {
      analogWrite(9,LOW);
      analogWrite(10,LOW);
  }

  if (GamePad.isLeftPressed())
  {
     serial1.print("Left");
     analogWrite(11,HIGH);
     analogWrite(6,LOW);
  } else {
    analogWrite(11,LOW);
    serial1.print("Left");
  }

  if (GamePad.isRightPressed())
  {
    serial1.print("Right");
    analogWrite(11,HIGH);
    analogWrite(6,HIGH);
  } else {
    analogWrite(11,LOW);
    analogWrite(6,LOW);
    serial1.print("Right");
  }

  if (GamePad.isSquarePressed())
  {
    serial1.print("Square");
  }

  if (GamePad.isCirclePressed())
  {
    serial1.print("Circle");
  }

  if (GamePad.isCrossPressed())
  {
    serial1.print("Cross");
  }

  if (GamePad.isTrianglePressed())
  {
    serial1.print("Triangle");
  }

  if (GamePad.isStartPressed())
  {
    serial1.print("Start");
  }

  if (GamePad.isSelectPressed())
  {
    serial1.print("Select");
  }
  serial1.print('\t');

  int a = GamePad.getAngle();
  serial1.print("Angle: ");
  serial1.print(a);
  serial1.print('\t');
  int b = GamePad.getRadius();
  serial1.print("Radius: ");
  serial1.print(b);
  serial1.print('\t');
  float c = GamePad.getXaxisData();
  serial1.print("x_axis: ");
  serial1.print(c);
  serial1.print('\t');
  float d = GamePad.getYaxisData();
  serial1.print("y_axis: ");
  serial1.println(d);
  serial1.println();
}
