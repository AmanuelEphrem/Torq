//includes libraries
#include <SoftwareSerial.h>
#include <VescUart.h>


//--creates variables--
//instances of bluetooth and vesc
SoftwareSerial ble(8, 9); // RX, TX
VescUart vesc;
//info sent
int elSpeed = 255;
int elBattery = 255;
int elConnected = 0;
double elDistance = 0;

//info reveived
int elControl = -255;

//misc variables
int temp = 0;//stores temporary information

//variables for determining battery
int prevRead = -1;    //previous battery level
boolean onOrOff = false;  //represents whether el is pressed off
long startTime = millis();//start time to determine battery calculation
long endTime;         //end time to determine battery calculation

//variables for determining distance
long distanceStart = millis();
long distanceEnd =-1;
int tempAnswer;
double cumulativeDistance;
long elapsed;

//--runs setup (only once)--
void setup() {
  //begin debugging serial port 
  Serial.begin(9600);
  //begin bluetooth serial port 
  ble.begin(9600);
  //begin VESC serial port
  Serial1.begin(115200);
  //connect vesc serial port
  vesc.setSerialPort(&Serial1);
  pinMode(12,OUTPUT);
}

//--runs loop every 50 ms (repetitive)--
void loop() {
  //updates sent values
  updateValues();
  //sends and recieves values from central
  if(ble.available()){
      //receives messge and validates its authenticity
      temp = ble.read();
      elControl = (temp == 45 || temp == 55) ? temp : elControl;
      delay(20);
      
      //sends message
      ble.print(""+String(elSpeed)+"$"+String(elBattery)+"$"+String(elConnected)+"$"+String(elDistance));
      delay(20);
  }
  //determines buzzer status
  buzzer();
  //delays so cumulative delay is 50 ms
  delay(30);


}
//updates info sent from vesc
//@returns: nothing
//@changes: info sent variables
void updateValues(){
    if(vesc.getVescValues()){
        elConnected = 1;
        elSpeed = (((((vesc.data.rpm/7.0)*85.0)*3.1415926)*0.00003728226)*(16.0/36.0));//(((((vesc.data.rpm)/7.0)*60)*((85*3.14)/2.25))/(1.06*1000000));
        elBattery = reMap(determineBattery(vesc.data.inpVoltage));
        determineDistance();
        Serial.println(elSpeed);
    }
    
}
//determines current battery
//@return: current battery level
//@changes: elConnected, startTime, endTime, prevRead, off
int determineBattery(int currentBattery){
  endTime = millis();
  if((endTime-startTime) < 500){
      return prevRead;
  }else if(onOrOff == true){
      elConnected = 0;
      return 31;
  }else if(prevRead > 0 && (currentBattery <= (prevRead-2))){
      onOrOff = true;
      elConnected = 0;
      prevRead = currentBattery;
      return 31;
  }else{
      startTime = millis();
      prevRead = currentBattery;
      return currentBattery;
  }
}

int determineDistance(){
  //determines distance
  distanceEnd = millis();
  elapsed = distanceEnd - distanceStart;
  cumulativeDistance += (elSpeed*1.0 * (elapsed*(1/(3.6*1000000.0))));
  elDistance = cumulativeDistance;
  tempAnswer = (int) (elDistance*100);
  elDistance = tempAnswer/100.0;
  distanceStart = millis();
}

//maps the battery output to a range of [0,100]
int reMap(int target){
  return (int) ((((target*1.0)-31.0)/(40.0-31.0))*(100.0));
}

void buzzer(){

  if(elConnected == 1 && elControl == 55){
      tone(11,900);
  }else{
      noTone(11);
  }
}
