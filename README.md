# Torq
Torq is an iPhone app I built for an electric longboard I was making, in order to track a variety of metrics associated with it. Torq is able to show you your current speed, total distance traveled, speed mode, and current battery level. If an external speaker is attached, Torq also allows you to control a buzzing sound to alert pedestrians/riders around you. The app uses biometric authentication (face ID) in order to ensure only authorized people can look at your longboard’s metrics, and it supports dark mode for aesthetic purposes.

## How it works
### Overview
Torq works by communicating directly with the electric longboard’s electronic speed controller (VESC) to gather metric information. In order for Torq to communicate directly with the VESC, an arduino is used to take information from the VESC so that it can send it to the app using bluetooth low energy (BLE). The communication happening between the arduino and VESC is done through the UART protocol (which is managed by [SolidGeek's library](https://github.com/SolidGeek/VescUart) in this project). Once the arduino is able to receive the electric longboard’s RPM and input voltage information via UART from the VESC, it is able to calculate the speed, distance traveled, and battery level of the electric longboard. These three pieces of information are then sent to Torq via an HM-10 bluetooth module. Torq is able to read the messages sent from the arduino using Core Bluetooth in Swift. After Torq receives the message from the arduino, it sends its own information and this cycle of sending messages - which is outlined in the ELCommunicationProtocol (see below) - continues until the app terminates. 

### ELCommunication Protocol
This is a protocol I’ve created in order to easily define how communication between the arduino and Torq should occur over BLE. At a high level, the ELCommunicationProtocol uses a call-response method of communication, where one device (the initiator) sends information and waits until it receives a response from a second device (the follower). After the follower has finished sending its own information, the initiator will receive the information and send its own information, again. This cycle will continue to repeat until the app terminates. In this project the arduino takes the role as the initiator, and Torq takes the role as the follower. As its name suggests, the arduino will initiate the communication when the electric longboard turns on, and will expect an immediate response from Torq afterwards. Each message sent from the arduino to Torq is a string that looks something like this:

```Speed$Battery$Connected$Distance```

The message contains the electric longboard’s speed, battery level, connection status (whether it is on or off), and distance traveled information. The dollar sign character between each piece of information acts as a delimiter in the message. This way of formatting messages is not only simple, but also allows for more information to be added to the message easily (just add the dollar sign character and a new piece of information to the end of the message). The information sent from Torq to the arduino looks something like this.

```Buzzer```

The single piece of information in this message is a numerical value that represents whether a buzzing sound should be on or off.  Because it is only one piece of information, no dollar sign characters are needed.  

## How to implement
In order to use this repository on your own DIY electric longboard project, you would need to make sure you are using a VESC for your electronic speed controller, have access to an arduino with two serial ports (arduino micro is recommended), and also have access to a BLE sensor that uses RX/TX pins to communicate ([this](https://www.amazon.com/DSD-TECH-Bluetooth-iBeacon-Arduino/dp/B06WGZB2N4/ref=sr_1_1_sspa?dchild=1&keywords=dsd+tech+hm-10&qid=1609039395&s=electronics&sr=1-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExQVRTVzdHWkhSQjFRJmVuY3J5cHRlZElkPUEwMjI3MjA3TzhPOUpMREtKRTVPJmVuY3J5cHRlZEFkSWQ9QTA2OTcyODkzMzdSV0FSMkhKRkdLJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==) sensor is recommended). Below are instructions on how to run the arduino sketch and xcode project after downloading this repository.

### Arduino
Before running any software, **you must first wire the arduino** as shown [here](/ArduinoWiring.png). After wiring you may download [SolidGeek's library](https://github.com/SolidGeek/VescUart), which is the only dependency needed for the arduino file (ProjectTORQ.ino). After downloading SolidGeek's library and importing it to Arduino’s IDE, all that must be done is to upload the ProjectTORQ.ino sketch to your arduino. 

### Xcode
The xcode project (the Torque folder) has no dependencies, so all that must be done is to build and run the application on a connected iPhone (the simulator will not be able to connect to bluetooth). 


\*After opening Torq on your iPhone, turn on your electric longboard and enjoy *all* of Torq’s features!

## App Screenshots
Screenshots of all the screens can be found in [this folder](/AppScreenshots). The design file for Torq (in Adobe XD) can also be found [here](TorqDesign.xd).
