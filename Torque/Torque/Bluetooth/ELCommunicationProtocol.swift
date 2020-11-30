//
//  ELCommunicationProtocol.swift
//  Torque
//
//  Created by Amanuel on 6/30/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
class ELCommunicationProtocol: CBCentralManager, CBPeripheralDelegate, CBCentralManagerDelegate{
    //bluetooth properties
    private var centralManager : CBCentralManager!
    private var peripheral : CBPeripheral!
    private var characteristic : CBCharacteristic?
    private var time = Timer()


     init() {
        super.init(delegate: centralManager as? CBCentralManagerDelegate, queue: DispatchQueue.main, options: nil)
        //updates metrics (startup)
        ELMetrics.speed.value = "---"
        ELMetrics.battery.value = "---"
        ELMetrics.connected.value = "0"
        ELMetrics.distance.value = "---"
        ELMetrics.didUpdate.value = "yes"
        
        //init continuous ble
        centralManager = CBCentralManager(delegate: self, queue: nil)
        scheduledTimerWithTimeInterval()
    }
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateTime" with the interval of 100 milisecond
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
//ble device connect functions -------
    //updates when peripheral is switched on or off
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", BLEDevice.ELService);
            centralManager.scanForPeripherals(withServices: [BLEDevice.ELService],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    //event occures when central gets scan results
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
    }
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to Peripheral")
            peripheral.discoverServices([BLEDevice.ELService])
        }
    }
    //updates when all services have been discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLEDevice.ELService {
                    print("Service Found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([BLEDevice.ELChar], for: service)
                    return
                }
            }
        }
    }
    //provides characteristics for a given uuid
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            
            for characteristic in characteristics {
                print(characteristics.count)
                if characteristic.uuid == BLEDevice.ELChar{
                    print("Characteristic Found : \(characteristic.uuid)")
                    self.characteristic = characteristic
                    self.peripheral.setNotifyValue(true, for: self.characteristic!)

                    let info = UInt8(66)
                    updatePotVal(newValue: Data([info]))
                    return
                }
            }
        }
    }
    //handles bluetooth disconnect
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if(peripheral == self.peripheral){
            print("Disconnected")
            
            //updates ELMetrics
            ELMetrics.speed.value = "---"
            ELMetrics.battery.value = "---";
            ELMetrics.connected.value = "0";
            ELMetrics.distance.value = "---"
            ELMetrics.didUpdate.value = "yes"
            
            //updates instance variables
            self.peripheral = nil
            self.characteristic = nil
            
            //tries to connect to a bluetooth again
            print("Central scanning for", BLEDevice.ELService);
            centralManager.scanForPeripherals(withServices: [BLEDevice.ELService],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    //called when peripheral sends information - needed to keep characteristic value up to date--
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        self.characteristic = characteristic
    }
  
//updating ELMetrics with correct values -------
    //updates every 100 ms
    func updatePotVal(newValue val:Data){
        writeData()
        let stringValue = String(decoding: val, as: UTF8.self)
        if(stringValue.count >= 5){
            formatInput(str: stringValue)
        }

    }
    //seperates received message
    private func formatInput(str : String){
        let arr = Array(str)
        var seperator = 0;
        var speed = ""
        var battery = ""
        var connected = ""
        var distance = ""
        for i in arr{
            if(i == "$"){
                seperator+=1
            }else if(seperator == 0){
                speed+=String(i)
            }else if(seperator == 1){
                battery+=String(i)
            }else if(seperator == 2){
                connected+=String(i)
            }else if(seperator == 3){
                distance+=String(i)
            }
        }
        //updates metrics (connected)
        if(connected == "1"){
            ELMetrics.speed.value = speed
            ELMetrics.battery.value = battery
            ELMetrics.connected.value = connected
            ELMetrics.distance.value = distance
            ELMetrics.didUpdate.value = "yes"
        }
    }
    //function called when timer executes every 100  ms
    @objc func updateTime(){
        //only proceed if there is information
        if(characteristic?.value != nil){
            updatePotVal(newValue: characteristic!.value!)
        }

        
    }
    //writes information back to el
    private func writeData(){
        //makes sure if characteristic can be written to and peripheral exists
        let data = UInt8(ELMetrics.onOrOff.value)!
        if(self.characteristic!.properties.contains(.writeWithoutResponse) && peripheral != nil){
            peripheral.writeValue(Data([data]), for: characteristic!, type: .withoutResponse)
        }
    }
}
