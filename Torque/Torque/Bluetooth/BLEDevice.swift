//
//  BLEDevice.swift
//  Torque
//
//  Created by Amanuel on 6/30/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//  Note: el = electric skateboard

import UIKit
import CoreBluetooth
class BLEDevice: NSObject {
    //DSD Tech BLE Module specs inside el
    public static let ELService = CBUUID.init(string: "FFE0")
    public static let ELChar = CBUUID.init(string: "FFE1")
}
