//
//  TestViewController.swift
//  Torque
//
//  Created by Amanuel on 7/26/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var BatteryLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupObservers()
    }
    
    //removes notification center when view is removed
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //setsup notification observers for this view
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(TestViewController.updateUI), name: Notification.Name(rawValue: NotificationName.updateNotif), object: nil)
    }
    //updates ui
    @objc func updateUI(){
        speedLbl.text = ELMetrics.speed.value
        BatteryLbl.text = ELMetrics.battery.value == "0" ? "---" : ELMetrics.battery.value
        statusLbl.text = ELMetrics.connected.value == "0" ? "---" : ELMetrics.connected.value
    }

}
