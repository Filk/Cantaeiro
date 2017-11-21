#include "Arduino.h"
#include "SoftwareSerial.h"
#include "DFRobotDFPlayerMini.h"

SoftwareSerial mySoftwareSerial(10, 11); // RX, TX
DFRobotDFPlayerMini myDFPlayer;

int analogPinCondutividade=0;
int threshold=70;
boolean readyToPlay=true;

int analogPinPotenciometro=1;

void setup() 
{
  Serial.begin(2400);
  mySoftwareSerial.begin(9600);
  
  if (!myDFPlayer.begin(mySoftwareSerial)) 
  {  
    //Use softwareSerial to communicate with mp3.
    Serial.println(F("Unable to begin:"));
    Serial.println(F("1.Please recheck the connection!"));
    Serial.println(F("2.Please insert the SD card!"));
    while(true);
  }
  
  myDFPlayer.volume(24);  //Set volume value. From 0 to 30
  myDFPlayer.pause();  //pause
}

void loop() 
{
  int leituraCondutividade = analogRead(analogPinCondutividade);
  Serial.println("Condutividade");
  Serial.println(leituraCondutividade);
  int leituraPotenciometro = analogRead(analogPinPotenciometro);
  Serial.println("Potenciometro");
  Serial.println(leituraPotenciometro);
  threshold=leituraPotenciometro;

  if (leituraCondutividade<threshold && readyToPlay)
  {
    myDFPlayer.next();
    readyToPlay=false;
  }

  static unsigned long timer = millis();
  
  if (millis() - timer > 3000 && leituraCondutividade >=threshold) 
  {
    timer = millis();
    readyToPlay=true;
  }

}
