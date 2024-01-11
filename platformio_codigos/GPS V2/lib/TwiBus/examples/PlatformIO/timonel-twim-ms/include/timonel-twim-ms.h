/*
  timonel-twim-ms.h
  ==================
  Timonel library test header (Multi Slave) v1.5
  ----------------------------------------------------------------------------
  2020-07-13 Gustavo Casanova
  ----------------------------------------------------------------------------
*/

#ifndef TIMONEL_TWIM_MS_H
#define TIMONEL_TWIM_MS_H

#include <NbMicro.h>
#include <TimonelTwiM.h>
#include <TwiBus.h>

// This software
#define VER_MAJOR 1
#define VER_MINOR 5
#define VER_PATCH 0

// Serial display settings
#define USE_SERIAL Serial
#define SERIAL_BPS 115200

// I2C pins
#define SDA 2  // I2C SDA pin - ESP8266 2 - ESP32 21
#define SCL 0  // I2C SCL pin - ESP8266 0 - ESP32 22

// Routine settings
#define MAX_TWI_DEVS 28
#define LOOP_COUNT 3
#define T_SIGNATURE 84

// Prototypes
void setup(void);
void loop(void);
bool CheckApplUpdate(void);
//void PrintStatus(Timonel timonel);
Timonel::Status PrintStatus(Timonel *timonel);
void ThreeStarDelay(void);
void ShowHeader(void);
void PrintLogo(void);
void ClrScr(void);

#endif  // TIMONEL_TWIM_MS_H