
bool   response = 0;
String response_data = "";
String send_data="";
void setup() {
  Serial.begin(250000);
  Serial3.begin(38400);
  checkATresponse();
 
}

void loop() {
  Serial.println("Enter 1");
  while(Serial.available()==0);
  while(Serial.available()!=0)
  {
    uint8_t a=Serial.read();
    if(a == '1')
    {
      readBaudRate();
    }
    if(a == '2')
    {
      writeBaudRate(); 
    }
  }
}

void checkATresponse()
{
  long lastTime=0;
  while (!(response))
  {
    Serial3.print("AT\r\n");
    response_data = Serial3.readString();
    if (response_data != '\0')                
    {
    Serial.print("Command sent: "); 
    Serial.println("AT");
    Serial.print("Command received: ");
    Serial.println(response_data);
    response++;
    }
  }
  response=0;
}

void readBaudRate()
{
  while (!(response))
  {
    Serial3.print("AT+UART?\r\n");
    response_data = Serial3.readString();
    if (response_data != '\0')                
    {
    Serial.print("Command sent: ");   
    Serial.println("AT+UART?");
    Serial.print("Command received: ");
    Serial.println(response_data);
    response++;
    }
  }
  response=0;
}

void writeBaudRate()
{
  Serial.println("Enter any baudrate as per requirement. Some of the most commonly used baudrates are 9600, 38400,57600 and 115200.");
  Serial.println("Waiting for you to enter Baudrate...");
  while(Serial.available()==0);
  while(Serial.available()!=0)
  {
    send_data=Serial.readString();
    Serial.println(send_data);
  }
   while (!(response))
  {
    Serial3.print(String("AT+UART="+send_data+",0,0\r\n"));
    response_data = Serial3.readString();
    if (response_data != '\0')                
    {
    Serial.print("Command sent: ");   
    Serial.println(String("AT+UART="+send_data+",0,0"));
    Serial.print("Command received: ");
    Serial.print(response_data);
    response++;
    }
    if(response_data == "OK\r\n")
    {
      Serial.println("successfully");
    }
    else
    {
      Serial.println("Error");
    }
  }
  response=0;
}
