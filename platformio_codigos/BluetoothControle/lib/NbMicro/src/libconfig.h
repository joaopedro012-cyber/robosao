/*
  libconfig.h
  =================================
  NbMicro configuration
  ---------------------------------
  Version: 1.2.0 / 2020-07-13
  gustavo.casanova@gmail.com
  ---------------------------------
*/

#ifndef NBMICRO_CONFIG_H
#define NBMICRO_CONFIG_H

/////////////////////////////////////////////////////////////////////////////
////////////                  NbMicro settings                   ////////////
/////////////////////////////////////////////////////////////////////////////

// General defs
#ifndef DEBUG_LEVEL
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
#define DEBUG_LEVEL 0      // Debug level: 0 = No debug info over serial terminal, 1+ = Progressively increasing verbosity
#else                      // -----
#define DEBUG_LEVEL false  // NOTE: DEBUG not implemented for platforms other than ESP8266 and ESP32.
#endif                     // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
#endif                     // DEBUG_LEVEL
#ifndef USE_SERIAL
#define USE_SERIAL Serial
#endif                    // USE_SERIAL
#define SDA_STD_PIN 4     // I2C SDA standard pin on ESP866 boards
#define SCL_STD_PIN 5     // I2C SCL standard pin on ESP866 boards
#define LOW_TWI_ADDR 8    // Lowest allowed TWI address on slave devices
#define HIG_TWI_ADDR 63   // Highest allowed TWI address on slave devices
#define TWI_DEVICE_QTY 5  // Simultaneous TWI devices that an application supports (AVR only)
// End general defs

// NbMicro::constructor defs
#define DLY_NBMICRO 500  // Delay before canceling NbMiccro object creation (ms)
// End NbMicro::constructor defs

// NbMicro::SetTwiAddress defs
#define ERR_ADDR_IN_USE 1  // Error: The TWI address is already taken
// End NbMicro::SetTwiAddress defs

// NbMicro::TwiCmdXmit defs
#define STOP_ON_REQ true   // Config: true=master releases the bus with "stop" after a request, false=sends restart
#define ERR_CMD_PARSE_S 1  // Error: reply doesn't match command (single byte)
#define ERR_CMD_PARSE_M 2  // Error: reply doesn't match command (multi byte)
// End NbMicro::TwiCmdXmit defs

/////////////////////////////////////////////////////////////////////////////
////////////                    End settings                     ////////////
/////////////////////////////////////////////////////////////////////////////

#endif  // NBMICRO_CONFIG_H
