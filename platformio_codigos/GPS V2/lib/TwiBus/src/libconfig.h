/*
  libconfig.h
  =================================
  TwiBus configuration
  ---------------------------------
  Version: 1.2.0 / 2020-07-13
  gustavo.casanova@gmail.com
  ---------------------------------
*/

#ifndef TWIBUS_CONFIG_H
#define TWIBUS_CONFIG_H

/////////////////////////////////////////////////////////////////////////////
////////////                   TwiBus settings                   ////////////
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
#endif                       // USE_SERIAL
#define DETECT_TIMONEL true  // Enable Timonel bootloader detection
#define SDA_STD_PIN 4        // I2C SDA standard pin on ESP866 boards
#define SCL_STD_PIN 5        // I2C SCL standard pin on ESP866 boards
#define LOW_TWI_ADDR 8       // Lowest allowed TWI address on slave devices
#define HIG_TWI_ADDR 63      // Highest allowed TWI address on slave devices
#define DLY_SCAN_BUS 1       // TWI scanner pass delay
#define L_TIMONEL "Timonel"  // Literal: Timonel
#define L_UNKNOWN "Unknown"  // Literal: Unknown
#define L_APP "Application"  // Literal: Application
// End general defs

/////////////////////////////////////////////////////////////////////////////
////////////                    End settings                     ////////////
/////////////////////////////////////////////////////////////////////////////

#endif  // TWIBUS_CONFIG_H
