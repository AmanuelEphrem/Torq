//
//  ELMetrics.swift
//  Torque
//
//  Created by Amanuel on 6/30/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//  Note: el = electric skateboard

import UIKit

class ELMetrics: NSObject {
    //metrics asssociated with el
    public static var speed = ELData(value: "---")
    public static var battery = ELData(value: "---")
    public static var connected = ELData(value: "---")
    public static var distance = ELData(value: "---")
    public static var didUpdate = ELData(value: "---"){
        didSet{
            let name = Notification.Name(rawValue: NotificationName.updateNotif)
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    //metrics for sending to el
    public static var onOrOff = ELData(value: "45")
    //metrics associated with code//gets from user defaults if previously put
    public static var name = ELData(value: "Placeholder")
    public static var darkMode = ELData(value: "no")
}
