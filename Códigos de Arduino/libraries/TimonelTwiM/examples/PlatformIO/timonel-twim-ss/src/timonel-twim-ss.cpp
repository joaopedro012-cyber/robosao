/*
  timonel-twim-ss.cpp
  ===================
  Timonel library test program (Single Slave) v1.5
  ----------------------------------------------------------------------------
  This demo implements an I2C serial commander to control interactively a
  Tiny85 microcontroller running the Timonel bootloader from an ESP8266
  master. It uses a serial console configured at 115200 N 8 1 for feedback.
  ----------------------------------------------------------------------------
  2020-07-13 Gustavo Casanova
  ----------------------------------------------------------------------------
*/

#include "timonel-twim-ss.h"

#include "payload.h"

// Global variables
bool new_key = false;
bool new_word = false;
bool *p_app_mode = nullptr;
char key = '\0';
uint16_t flash_page_addr = 0x0000;
uint16_t eeprom_addr = 0x0000;
Timonel *p_timonel = nullptr;     // Pointer to a bootloader objetct
// If the user application only needs simple I2C commands, it is enough to create just a
// Timonel object. Since it inherits from NbMicro, so the "TwiCmdXmit" method is available.
void (*resetFunc)(void) = 0;

// Setup block
void setup() {
    bool app_mode = false;         // This holds the slave device running mode info: bootloader or application
    p_app_mode = &app_mode;        // This is to take different actions depending on whether the bootloader or the application is active
    USE_SERIAL.begin(SERIAL_BPS);  // Initialize the serial port for debugging
    ClrScr();
    PrintLogo();
    uint8_t slave_address = 0;
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
    USE_SERIAL.printf_P("\n\rWaiting until a TWI slave device is detected on the bus   ");
#else   // -----
    USE_SERIAL.print("\n\rWaiting until a TWI slave device is detected on the bus   ");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    slave_address = DiscoverDevice(p_app_mode, SDA, SCL);
    ShowHeader(*p_app_mode);
    p_timonel = new Timonel(slave_address, SDA, SCL);
    if (!(*p_app_mode)) {
        // p_timonel = new Timonel(slave_address, SDA, SCL);
        p_timonel->GetStatus();
        PrintStatus(p_timonel);
    } else {
        //p_micro = new NbMicro(slave_address, SDA, SCL);
    }
    ShowMenu(*p_app_mode);
}

// Main loop
void loop() {
    if (new_key == true) {
        new_key = false;
        DiscoverDevice(p_app_mode, SDA, SCL);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
        USE_SERIAL.printf_P("\b\n\r");
#else   // -----
            USE_SERIAL.println("");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
        if (*p_app_mode) {
            // ....................
            // . APPLICATION MODE .
            // ....................
            switch (key) {
                // *********************************
                // * Test app ||| STDPB1_1 Command *
                // *********************************
                case 'a':
                case 'A': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\rApplication Cmd >>> Starting blink");
#else   // -----
                        USE_SERIAL.print("\n\rApplication Cmd >>> Starting blink");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    byte ret = p_timonel->TwiCmdXmit(SETIO1_1, ACKIO1_1);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    if (ret) {
                        USE_SERIAL.printf_P(" > Error: %d\n\n\r", ret);
                    } else {
                        USE_SERIAL.printf_P(" > OK!\n\n\r");
                    }
#else   // -----
                        if (ret) {
                            USE_SERIAL.print(" > Error: %d");
                            USE_SERIAL.println(ret);
                        } else {
                            USE_SERIAL.println(" > OK!");
                        }
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // *********************************
                // * Test app ||| STDPB1_0 Command *
                // *********************************
                case 's':
                case 'S': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\rApplication Cmd >>> Stopping blink");
#else   // -----
                        USE_SERIAL.print("\n\rApplication Cmd >>> Starting blink");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    byte ret = p_timonel->TwiCmdXmit(SETIO1_0, ACKIO1_0);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    if (ret) {
                        USE_SERIAL.printf_P(" > Error: %d\n\n\r", ret);
                    } else {
                        USE_SERIAL.printf_P(" > OK!\n\n\r");
                    }
#else   // -----
                        if (ret) {
                            USE_SERIAL.print(" > Error: %d");
                            USE_SERIAL.println(ret);
                        } else {
                            USE_SERIAL.println(" > OK!");
                        }
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // *********************************
                // * Test app ||| RESETINY Command *
                // *********************************
                case 'z':
                case 'Z': {
                    byte ret = p_timonel->TwiCmdXmit(RESETMCU, ACKRESET);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n  .\n\r . .\n\r. . .\n\n\r");
                    if (ret) {
                        USE_SERIAL.printf_P(" > Error: %d\n\n\r", ret);
                    } else {
                        USE_SERIAL.printf_P(" > OK resetting!\n\n\r");
                    }
#else   // -----
                        USE_SERIAL.print("\n  .\n\r . .\n\r. . .\n\n\r");
                        //Wire.begin();
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    delay(MODE_SWITCH_DLY);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    ESP.restart();
#else   // ------
                    resetFunc();
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // ******************
                // * ? Help command *
                // ******************
                case '?':
                case 'h':
                case 'H': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\r Help: Available application commands:\n\r");
                    USE_SERIAL.printf_P(" =====================================\n\r");
                    USE_SERIAL.printf_P(" a) Start LED blinking on device PB1.\n\r");
                    USE_SERIAL.printf_P(" s) Stop LED blinking on device PB1.\n\r");
                    USE_SERIAL.printf_P(" z) Reset both micros, I2C master and slave.\n\n\r");
#else   // -----
                        USE_SERIAL.println("\b\rHelp ...\n\r========\n\n\r");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    //ShowHelp();
                    break;
                }
            }
        } else {
            // ...................
            // . BOOTLOADER MODE .
            // ...................
            switch (key) {
                // ******************
                // * Restart master *
                // ******************
                case 'z':
                case 'Z': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\nResetting TWI Master ...\n\r\n.\n.\n.\n");
                    delay(MODE_SWITCH_DLY);
                    ESP.restart();
#else   // -----
                        USE_SERIAL.print("\nResetting TWI Master ...\n\r\n.\n.\n.\n");
                        resetFunc();
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // ********************************
                // * Timonel ::: GETTMNLV command *
                // ********************************
                case 'v':
                case 'V':
                case 13 : {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\nBootloader Cmd >>> Get bootloader version ...\r\n");
#else   // -----
                        USE_SERIAL.println("\nBootloader Cmd >>> Get bootloader version ...");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    PrintStatus(p_timonel);
                    //p_timonel->GetStatus();
                    //Timonel::Status sts = p_timonel->GetStatus();
                    //Timonel::Status sts = PrintStatus(p_timonel);
                    // if ((sts.features_code >> F_CMD_SETPGADDR) & true) {
                    //     p_timonel->InitMicro();
                    // }                        
                    TwiBus twi_bus(SDA, SCL);
                    twi_bus.ScanBus(p_app_mode);
                    break;
                }
                // ********************************
                // * Timonel ::: EXITTMNL command *
                // ********************************
                case 'r':
                case 'R': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\nBootloader Cmd >>> Run application ...\r\n");
                    USE_SERIAL.printf_P("\n. . .\n\r . .\n\r  .\n\n\r");
                    USE_SERIAL.printf_P("Please wait ...\n\n\r");
#else   // -----
                    USE_SERIAL.println("\nBootloader Cmd >>> Run application ...");
                    USE_SERIAL.println("\n. . .\n\r . .\n\r  .\n");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    // The GetStatus command below is to ensure that the remote device is properly initialized
                    // before running this case's command (e.g. when running after a firmware deletion)
                    // p_timonel->GetStatus();
                    uint8_t cmd_errors = p_timonel->RunApplication();
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    if (cmd_errors == 0) {
                        USE_SERIAL.printf_P("Bootloader exit successful, running the user application (if there is one) ...\r\n");
                    } else {
                        USE_SERIAL.printf_P(" [ command error! %d ]", cmd_errors);
                    }
                    //USE_SERIAL.printf_P("\n\n\r");
#else   // -----
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    delay(MODE_SWITCH_DLY);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    // ESP.restart();
                    delete p_timonel;
                    USE_SERIAL.printf_P("\n\rWaiting for device   ");             
                    uint8_t slave_address = DiscoverDevice(p_app_mode, SDA, SCL);
                    //USE_SERIAL.printf_P("\n\r");
                    p_timonel = new Timonel(slave_address, SDA, SCL);
                    ShowHeader(*p_app_mode);
                    USE_SERIAL.printf_P("\n\r");
                    // ShowMenu(*p_app_mode);
#else   // -----
                        resetFunc();
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // ********************************
                // * Timonel ::: DELFLASH command *
                // ********************************
                case 'e':
                case 'E': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\rBootloader Cmd >>> Delete app firmware from flash memory, \x1b[5mPLEASE WAIT\x1b[0m ...");
#else   // -----
                        USE_SERIAL.print("\n\rBootloader Cmd >>> Delete app firmware from flash memory, \x1b[5mPLEASE WAIT\x1b[0m ...");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    uint8_t cmd_errors = p_timonel->DeleteApplication();
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
                    if (cmd_errors == 0) {
                        USE_SERIAL.printf_P(" successful        ");
                    } else {
                        USE_SERIAL.printf_P(" [ command error! %d ]", cmd_errors);
                    }
                    USE_SERIAL.printf_P("\n\r");
                    // USE_SERIAL.printf_P("\n\rDeleting firmware   ");
                    DiscoverDevice(p_app_mode, SDA, SCL);
                    // USE_SERIAL.printf_P("\n\r");                    
#else  // -----
                        USE_SERIAL.print("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
                        if (cmd_errors == 0) {
                            USE_SERIAL.print(" successful        ");
                        } else {
                            USE_SERIAL.print(" [ command error! ");
                            USE_SERIAL.print(cmd_errors);
                            USE_SERIAL.print(" ]");
                        }
                        USE_SERIAL.println("\n");
#endif  // #if ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
                // ********************************
                // * Timonel ::: STPGADDR command *
                // ********************************
                case 'b':
                case 'B': {
                    Timonel::Status sts = p_timonel->GetStatus();
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    if (((sts.features_code >> F_CMD_SETPGADDR) & true) == false) {                        
                        USE_SERIAL.printf_P("\n\rSet address command not supported by current Timonel features ...\n\r");
                        break;
                    }
                    USE_SERIAL.printf_P("\n\rPlease enter the flash memory page base address: ");
                    while (new_word == false) {
                        flash_page_addr = ReadWord();
                    }
                    if (new_word == true) {
                        USE_SERIAL.printf_P("\n\rFlash memory page base address: %d\r\n", flash_page_addr);
                        USE_SERIAL.printf_P("Address high byte: %d (<< 8) + Address low byte: %d\n\r", (flash_page_addr & 0xFF00) >> 8,
                                            flash_page_addr & 0xFF);
                        if (sts.bootloader_start > MCU_TOTAL_MEM) {
                            USE_SERIAL.printf_P("\n\n\rWarning: Timonel bootloader start address unknown, please run 'version' command to find it !\n\r");
                            break;
                        }
                        if ((flash_page_addr > (sts.bootloader_start - SPM_PAGESIZE)) | (flash_page_addr == 0xFFFF)) {
                            USE_SERIAL.printf_P("\n\rWarning: The highest flash page address available is %d (0x%X), please correct it !!!\n\n\r", sts.bootloader_start - SPM_PAGESIZE, sts.bootloader_start - SPM_PAGESIZE);
                            flash_page_addr = 0x0000;
                            break;
                        }
                    }
#else   // -----
                    if (((sts.features_code >> F_CMD_SETPGADDR) & true) == false) {
                        USE_SERIAL.println("\n\rSet address command not supported by current Timonel features ...");
                        break;
                    }
                    USE_SERIAL.print("\n\rPlease enter the flash memory page base address: ");
                    while (new_word == false) {
                        flash_page_addr = ReadWord();
                    }
                    if (new_word == true) {
                        USE_SERIAL.print("\n\rFlash memory page base address: ");
                        USE_SERIAL.println(flash_page_addr);
                        USE_SERIAL.print("Address high byte: ");
                        USE_SERIAL.print((flash_page_addr & 0xFF00) >> 8);
                        USE_SERIAL.print(" (<< 8) + Address low byte: ");
                        USE_SERIAL.println(flash_page_addr & 0xFF);
                        if (sts.bootloader_start > MCU_TOTAL_MEM) {
                            USE_SERIAL.println("\n\n\rWarning: Timonel bootloader start address unknown, please run 'version' command to find it !");
                            break;
                        }
                        if ((flash_page_addr > (sts.bootloader_start - SPM_PAGESIZE)) | (flash_page_addr == 0xFFFF)) {
                            USE_SERIAL.print("\n\n\rWarning: The highest flash page address available is ");
                            USE_SERIAL.print(sts.bootloader_start - SPM_PAGESIZE);
                            USE_SERIAL.print("(0x");
                            USE_SERIAL.print(sts.bootloader_start - SPM_PAGESIZE, HEX);
                            USE_SERIAL.println(" ), please correct it !!!");
                            break;
                        }
                    }
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    new_word = false;
                    break;
                }
                // ********************************
                // * Timonel ::: WRITPAGE command *
                // ********************************
                case 'w':
                case 'W': {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\rBootloader Cmd >>> Firmware upload to flash memory, \x1b[5mPLEASE WAIT\x1b[0m ...");
                    // The GetStatus command below is to ensure that the remote device is properly initialized
                    // before running this case's command (e.g. when running after a firmware deletion)
                    // p_timonel->GetStatus();
                    uint8_t cmd_errors = p_timonel->UploadApplication(payload, sizeof(payload), flash_page_addr);
                    USE_SERIAL.printf_P("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
                    if (cmd_errors == 0) {
                        USE_SERIAL.printf_P(" successful, press 'r' to run the user app");
                    } else {
                        USE_SERIAL.printf_P(" [ command error! %d ]", cmd_errors);
                    }
                    USE_SERIAL.printf_P("\n\n\r");
#else   // -----
                        USE_SERIAL.print("\n\rBootloader Cmd >>> Upload app firmware to flash memory, \x1b[5mPLEASE WAIT\x1b[0m ...");
                        uint8_t cmd_errors = p_timonel->UploadApplication(payload, sizeof(payload), flash_page_addr);
                        USE_SERIAL.print("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
                        if (cmd_errors == 0) {
                            USE_SERIAL.print(" successful, press 'r' to run the user app");
                        } else {
                            USE_SERIAL.print(" [ command error! ");
                            USE_SERIAL.print(cmd_errors);
                            USE_SERIAL.print(" ]");
                        }
                        USE_SERIAL.println("\n");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
#if ((defined FEATURES_CODE) && ((FEATURES_CODE >> F_CMD_READFLASH) & true))
                // ********************************
                // * Timonel ::: READFLSH command *
                // ********************************
                case 'm':
                case 'M': {
                    // (uint16_t) flash_size: MCU flash memory size
                    // (uint8_t) slave_data_size: slave-to-master Xmit packet size
                    // (uint8_t) values_per_line: MCU memory values shown per line
                    p_timonel->DumpMemory(MCU_TOTAL_MEM, SLV_PACKET_SIZE, 32);
                    break;
                }
#if ((defined EXT_FEATURES) && ((EXT_FEATURES >> E_EEPROM_ACCESS) & true))
                // ********************************
                // * Timonel ::: WRITEEPR command *
                // ********************************
                case 'p':
                case 'P': {
                    new_word = false;
                    uint8_t eeprom_data = 0;
                    USE_SERIAL.printf_P("\n\rPlease enter the EEPROM memory address: ");
                    while (new_word == false) {
                        eeprom_addr = ReadWord();
                    }
                    if (eeprom_addr > EEPROM_TOP) {
                        USE_SERIAL.printf_P("\n\rWarning: The highest EEPROM address available is %d (0x%X), please correct it !!!", EEPROM_TOP, EEPROM_TOP);
                        new_word = false;
                        break;
                    }
                    USE_SERIAL.printf_P("\n\rPlease enter EEPROM data: ");
                    //new_key = false;
                    new_word = false;
                    while (new_word == false) {
                        eeprom_data = ReadWord();
                    }
                    if (new_word == true) {
                        USE_SERIAL.printf_P("\n\r");
                        new_key = false;
                    }
                    USE_SERIAL.printf_P("\n\rWriting %d to EEPROM address 0x%04X\n\n\r", eeprom_data, eeprom_addr);
                    p_timonel->WriteEeprom(eeprom_addr, eeprom_data);
                    break;
                }
                // ********************************
                // * Timonel ::: READEEPR command *
                // ********************************
                case 'o':
                case 'O': {
                    USE_SERIAL.printf_P("\n\r");
                    for (uint16_t ee_addr = 0; ee_addr <= EEPROM_TOP; ee_addr++) {
                        USE_SERIAL.printf_P("%03d=%02d ", ee_addr, p_timonel->ReadEeprom(ee_addr));
                    }
                    USE_SERIAL.printf_P("\n\n\r");
                    break;
                }
#endif  // EXT_FEATURES >> E_EEPROM_ACCESS
#endif  /* CMD_READFLASH) */
                // *******************
                // * Unknown command *
                // *******************
                default: {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("Command '%d' unknown ...\n\r", key);
#else   // -----
                        USE_SERIAL.print("Unknown command: ");
                        USE_SERIAL.println(key);
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
                    break;
                }
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
                    USE_SERIAL.printf_P("\n\r");
#else   // -----
                        USE_SERIAL.println("");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
            }
        }
        ShowMenu(*p_app_mode);
    }
    ReadChar();
}

// Function ReadChar
void ReadChar(void) {
    if (USE_SERIAL.available() > 0) {
        key = USE_SERIAL.read();
        new_key = true;
    }
}

// Function ReadWord
uint16_t ReadWord(void) {
    const uint8_t data_length = 16;
    char serial_data[data_length];  // an array to store the received data
    static uint8_t ix = 0;
    char rc, endMarker = 0xD;  //standard is: char endMarker = '\n'
    while (USE_SERIAL.available() > 0 && new_word == false) {
        rc = USE_SERIAL.read();
        if (rc != endMarker) {
            serial_data[ix] = rc;
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
            USE_SERIAL.printf_P("%c", serial_data[ix]);
#else   // -----
                USE_SERIAL.print(serial_data[ix]);
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
            ix++;
            if (ix >= data_length) {
                ix = data_length - 1;
            }
        } else {
            serial_data[ix] = '\0';  // terminate the string
            ix = 0;
            new_word = true;
        }
    }
    return ((uint16_t)atoi(serial_data));
}

// Function DiscoverDevice
uint8_t DiscoverDevice(bool *p_app_mode, const uint8_t sda, const uint8_t scl) {
    uint8_t slave_address = 0;
    unsigned long start_time = 0;
    unsigned long now = millis();
    uint8_t rotary_state = 1;
    uint8_t *p_rotary = &rotary_state;    
    TwiBus twi_bus(sda, scl);
    while (slave_address == 0) {
        slave_address = twi_bus.ScanBus(p_app_mode);
        now = millis();
        if ((now - start_time) >= ROTATION_DLY) {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
            RotatingBar(p_rotary);
#else  // -----
            USE_SERIAL.printf(" .");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM            
            start_time = now;
        }
    }
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
    USE_SERIAL.printf_P("\b\b* ");
    USE_SERIAL.printf_P("\n\r");
#else  // -----
    USE_SERIAL.printf("\b\b* ");
    USE_SERIAL.println("");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    return slave_address;
}

// Function print Timonel instance status
Timonel::Status PrintStatus(Timonel *timonel) {
    Timonel::Status tml_status = timonel->GetStatus(); /* Get the instance id parameters received from the ATTiny85 */
    uint8_t twi_address = timonel->GetTwiAddress();
    uint8_t version_major = tml_status.version_major;
    uint8_t version_minor = tml_status.version_minor;
    uint16_t app_start = tml_status.application_start;
    uint8_t app_start_msb = ((tml_status.application_start >> 8) & 0xFF);
    uint8_t app_start_lsb = (tml_status.application_start & 0xFF);
    uint16_t trampoline = ((~(((app_start_lsb << 8) | app_start_msb) & 0xFFF)) + 1);
    trampoline = ((((tml_status.bootloader_start >> 1) - trampoline) & 0xFFF) << 1);
    if ((tml_status.signature == T_SIGNATURE) && ((version_major != 0) || (version_minor != 0))) {
        String version_mj_nick = "";
        switch (version_major) {
            case 0: {
                version_mj_nick = "\"Pre-release\"";
                break;
            }
            case 1: {
                version_mj_nick = "\"Sandra\"";
                break;
            }
            default: {
                version_mj_nick = "\"Unknown\"";
                break;
            }
        }
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
        USE_SERIAL.printf_P("\n\r Timonel v%d.%d %s ", version_major, version_minor, version_mj_nick.c_str());
        USE_SERIAL.printf_P("(TWI: %02d)\n\r", twi_address);
        USE_SERIAL.printf_P(" ====================================\n\r");
        USE_SERIAL.printf_P(" Bootloader address: 0x%X\n\r", tml_status.bootloader_start);
        if (app_start != 0xFFFF) {
            USE_SERIAL.printf_P("  Application start: 0x%04X (0x%X)\n\r", app_start, trampoline);
        } else {
            USE_SERIAL.printf_P("  Application start: 0x%04X (Not Set)\n\r", app_start);
        }
        USE_SERIAL.printf_P("      Features code: %d | %d ", tml_status.features_code, tml_status.ext_features_code);
        if ((tml_status.ext_features_code >> E_AUTO_CLK_TWEAK) & true) {
            USE_SERIAL.printf_P("(Auto)");
        } else {
            USE_SERIAL.printf_P("(Fixed)");
        }
        USE_SERIAL.printf_P("\n\r");
        USE_SERIAL.printf_P("           Low fuse: 0x%02X\n\r", tml_status.low_fuse_setting);
        USE_SERIAL.printf_P("             RC osc: 0x%02X", tml_status.oscillator_cal);
#if ((defined EXT_FEATURES) && ((EXT_FEATURES >> E_CMD_READDEVS) & true))
        if ((tml_status.ext_features_code >> E_CMD_READDEVS) & true) {
            Timonel::DevSettings dev_settings = timonel->GetDevSettings();
            USE_SERIAL.printf_P("\n\r ....................................\n\r");
            USE_SERIAL.printf_P(" Fuse settings: L=0x%02X H=0x%02X E=0x%02X\n\r", dev_settings.low_fuse_bits, dev_settings.high_fuse_bits, dev_settings.extended_fuse_bits);
            USE_SERIAL.printf_P(" Lock bits: 0x%02X\n\r", dev_settings.lock_bits);
            USE_SERIAL.printf_P(" Signature: 0x%02X 0x%02X 0x%02X\n\r", dev_settings.signature_byte_0, dev_settings.signature_byte_1, dev_settings.signature_byte_2);
            USE_SERIAL.printf_P(" Oscillator: 8.0Mhz=0x%02X, 6.4Mhz=0x%02X", dev_settings.calibration_0, dev_settings.calibration_1);
        }
#endif  // E_CMD_READDEVS
        USE_SERIAL.printf_P("\n\n\r");
#else   // -----
            USE_SERIAL.print("\n\r Timonel v");
            USE_SERIAL.print(version_major);
            USE_SERIAL.print(".");
            USE_SERIAL.print(version_minor);
            USE_SERIAL.print(" ");
            USE_SERIAL.print(version_mj_nick.c_str());
            USE_SERIAL.print(" TWI: ");
            USE_SERIAL.println(twi_address);
            USE_SERIAL.println(" ====================================");
            USE_SERIAL.print(" Bootloader address: 0x");
            USE_SERIAL.println(tml_status.bootloader_start, HEX);
            if (app_start != 0xFFFF) {
                USE_SERIAL.print("  Application start: 0x");
                USE_SERIAL.print(app_start, HEX);
                USE_SERIAL.print(" - 0x");
                USE_SERIAL.println(trampoline, HEX);
            } else {
                USE_SERIAL.print("  Application start: Not set: 0x");
                USE_SERIAL.println(app_start, HEX);
            }
            USE_SERIAL.print("      Features code: ");
            USE_SERIAL.print(tml_status.features_code);
            USE_SERIAL.print(" | ");
            USE_SERIAL.print(tml_status.ext_features_code);
            if ((tml_status.ext_features_code >> F_AUTO_CLK_TWEAK) & true) {
                USE_SERIAL.print(" (Auto)");
            } else {
                USE_SERIAL.print(" (Fixed)");
            }
            USE_SERIAL.println("");
            USE_SERIAL.print("           Low fuse: 0x");
            USE_SERIAL.println(tml_status.low_fuse_setting, HEX);
            USE_SERIAL.print("             RC osc: 0x");
            USE_SERIAL.println(tml_status.oscillator_cal, HEX);
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    } else {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
        USE_SERIAL.printf_P("\n\r *************************************************\n\r");
        USE_SERIAL.printf_P(" * User application running on TWI device %02d ... *\n\r", twi_address);
        USE_SERIAL.printf_P(" *************************************************\n\n\r");
#else   // -----
            USE_SERIAL.println("\n\r *******************************************************************");
            USE_SERIAL.print(" * Unknown bootloader, application or device at TWI address ");
            USE_SERIAL.println(twi_address);
            USE_SERIAL.println(" *******************************************************************\n");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    }
    return tml_status;
}

// Function ShowHeader
void ShowHeader(const bool app_mode) {
    delay(125);
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
    USE_SERIAL.printf_P("\n\r..............................................................\n\r");
    USE_SERIAL.printf_P(". Timonel I2C Bootloader and Application Test (v%d.%d twim-ss) .\n\r", VER_MAJOR, VER_MINOR);
    USE_SERIAL.printf_P("..............................................................\n\r");
    USE_SERIAL.printf_P(". Running mode: ");
    if (app_mode) {
        USE_SERIAL.printf_P("[ USER APPLICATION ]  ");
    } else {
        USE_SERIAL.printf_P("[ TIMONEL BOOTLOADER ]");
    }
    USE_SERIAL.printf_P("                       .\n\r");
    USE_SERIAL.printf_P("..............................................................\n\r");
    // if (app_mode) {
    //     USE_SERIAL.printf_P("\n\r");
    // }
#else   // -----
        USE_SERIAL.println("\n\r Timonel I2C Bootloader and Application Test (twim-ss)");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
}

// Function ShowMenu
void ShowMenu(const bool app_mode) {
    if (app_mode) {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
        USE_SERIAL.printf_P("Application command ('z' reset all, 'a' blink, 's' stop, '?' help): \x1b[5m_\x1b[0m");
#else   // -----
            USE_SERIAL.print("Application command ('a', 's', 'z' reboot, 'x' reset MCU, '?' help): ");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    } else {
        Timonel::Status sts = p_timonel->GetStatus();
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
        USE_SERIAL.printf_P("Timonel bootloader ('z' reset mst, 'v' version, 'r' run app, 'e' erase flash, 'w' write flash");
#if ((defined FEATURES_CODE) && ((FEATURES_CODE >> F_CMD_SETPGADDR) & true))
        if ((sts.features_code >> F_CMD_SETPGADDR) & true) {
            USE_SERIAL.printf_P(", 'b' set addr");
        }
#endif  // F_CMD_SETPGADDR
#if ((defined FEATURES_CODE) && ((FEATURES_CODE >> F_CMD_READFLASH) & true))
        if ((sts.features_code >> F_CMD_READFLASH) & true) {
            USE_SERIAL.printf_P(", 'm' mem dump");
        }
#endif  // F_CMD_READFLASH
#if ((defined EXT_FEATURES) && ((EXT_FEATURES >> E_EEPROM_ACCESS) & true))
        if ((sts.ext_features_code >> E_EEPROM_ACCESS) & true) {
            USE_SERIAL.printf_P(", 'o/p' read/write eeprom");
        }
#endif  // EXT_FEATURES >> E_EEPROM_ACCESS
        USE_SERIAL.printf_P("): ");
        USE_SERIAL.printf_P("\x1b[5m_\x1b[0m");
#else   // -----
            USE_SERIAL.print("Timonel bootloader ('v' version, 'r' run app, 'e' erase flash, 'w' write flash");
            if ((sts.features_code >> F_CMD_SETPGADDR) & true) {   
                USE_SERIAL.print(", 'b' set addr");
            }
            if ((sts.features_code >> F_CMD_READFLASH) & true) {                
                USE_SERIAL.print(", 'm' mem dump");
            }
            if ((sts.ext_features_code >> E_EEPROM_ACCESS) & true) {
                USE_SERIAL.print(", 'o/p' read/write eeprom");
            }
            USE_SERIAL.print("): ");
            USE_SERIAL.print("\x1b[5m_\x1b[0m");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
    }
}

// Function clear screen
void ClrScr() {
    USE_SERIAL.write(27);     // ESC command
    USE_SERIAL.print("[2J");  // clear screen command
    USE_SERIAL.write(27);     // ESC command
    USE_SERIAL.print("[H");   // cursor to home command
}

// Function PrintLogo
void PrintLogo(void) {
#if (ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM)
    USE_SERIAL.printf_P("        _                         _\n\r");
    USE_SERIAL.printf_P("    _  (_)                       | |\n\r");
    USE_SERIAL.printf_P("  _| |_ _ ____   ___  ____  _____| |\n\r");
    USE_SERIAL.printf_P(" (_   _) |    \\ / _ \\|  _ \\| ___ | |\n\r");
    USE_SERIAL.printf_P("   | |_| | | | | |_| | | | | ____| |\n\r");
    USE_SERIAL.printf_P("    \\__)_|_|_|_|\\___/|_| |_|_____)\\_)\n\r");
#else   // -----
        USE_SERIAL.print("        _                         _\n\r");
        USE_SERIAL.print("    _  (_)                       | |\n\r");
        USE_SERIAL.print("  _| |_ _ ____   ___  ____  _____| |\n\r");
        USE_SERIAL.print(" (_   _) |    \\ / _ \\|  _ \\| ___ | |\n\r");
        USE_SERIAL.print("   | |_| | | | | |_| | | | | ____| |\n\r");
        USE_SERIAL.print("    \\__)_|_|_|_|\\___/|_| |_|_____)\\_)\n\r");
#endif  // ARDUINO_ARCH_ESP8266 || ARDUINO_ESP32_DEV || ESP_PLATFORM
}

// Function RotaryDelay
void RotaryDelay(void) {
    USE_SERIAL.printf_P("\b\b| ");
    delay(ROTATION_DLY);
    USE_SERIAL.printf_P("\b\b/ ");
    delay(ROTATION_DLY);
    USE_SERIAL.printf_P("\b\b- ");
    delay(ROTATION_DLY);
    USE_SERIAL.printf_P("\b\b\\ ");
    delay(ROTATION_DLY);
}

// Function RotatingBar
void RotatingBar(uint8_t *rotary_state) {
    switch (*rotary_state) {
        case 1: {
            USE_SERIAL.printf_P("\b\b| ");
            *rotary_state += 1;
            break;
        }
        case 2: {
            USE_SERIAL.printf_P("\b\b/ ");
            *rotary_state += 1;
            break;
        }
        case 3: {
            USE_SERIAL.printf_P("\b\b- ");
            *rotary_state += 1;
            break;
        }
        case 4: {
            USE_SERIAL.printf_P("\b\b\\ ");
            *rotary_state = 1;
            break;
        }
        default: {
            break;
        }
    }
}
