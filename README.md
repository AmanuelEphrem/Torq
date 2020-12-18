# Torq: An app for an electric longboard
Torq is an iPhone app I built for an electric longboard I was making, in order to track a variety of metrics associated with it. Torq is able to show you your current speed, total distance traveled, speed mode, and current battery level. If an external speaker is attached, Torq also allows you to control a buzzing sound to alert pedestrians/riders around you. The app uses biometric authentication (face ID) in order to ensure only authorized people can look at your longboard’s metrics, and it supports dark mode for aesthetic purposes.

## How it works
Torq works by communicating directly with the electric longboard’s electronic speed controller (VESC) to gather metric information. In order for Torq to communicate directly with the VESC, an arduino is used to take information from the VESC so that it can send it to the app using bluetooth low energy (BLE). The communication happening between the arduino and VESC is done through the UART protocol (which is managed by [SolidGeek's library](https://github.com/SolidGeek/VescUart) in this project). Once the arduino is able to receive the electric longboard’s RPM and input voltage information via UART from the VESC, it is able to calculate the speed, distance traveled, and battery level of the electric longboard. These three pieces of information are then sent to Torq via an HM-10 bluetooth module. Torq is able to read the messages sent from the arduino using Core Bluetooth in Swift. Once Torq receives the message from the arduino, it sends its own information and this cycle of sending messages - which is outlined in the ELCommunicationProtocol (see below) - continues until the app terminates. 
