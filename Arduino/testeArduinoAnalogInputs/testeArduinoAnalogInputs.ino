//int analogPin0 = 0;
int analogPin1 = 3;
//int analogPin2 = 2;

//int val0 = 0;
int val1 = 0;
//int val2 = 0;

void setup()
{
  Serial.begin(1200);              //  setup serial
}

void loop()
{
//  val0 = analogRead(analogPin0);     // read the input pin
//  Serial.println(val0);             // debug value
  val1 = analogRead(analogPin1);     // read the input pin
  Serial.println(val1);             // debug value
//  val2 = analogRead(analogPin2);     // read the input pin
//  Serial.println(val2);             // debug value
}
