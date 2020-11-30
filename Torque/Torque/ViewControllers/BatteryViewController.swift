//
//  BatteryViewController.swift
//  Torque
//
//  Created by Amanuel on 7/4/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class BatteryViewController: UIViewController {
    @IBOutlet weak var batteryGreen: UIImageView!
    @IBOutlet weak var batteryLevelLbl: UILabel!
    @IBOutlet weak var batteryLbl: UILabel!
    @IBOutlet weak var blackCover: UIImageView!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(BatteryViewController.updateUI), name: Notification.Name(rawValue: NotificationName.updateNotif), object: nil)
    }

    //updates ui
    @objc func updateUI(){
        //determines light or dark mode
        if(ELMetrics.darkMode.value == "no"){
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            batteryLbl.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
            blackCover.alpha = 0;
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            batteryLbl.textColor = UIColor(red: 154/255, green: 153/255, blue: 153/255, alpha: 1)
            blackCover.alpha = 1;
        }
        
        batteryLevelLbl.text = "\(ELMetrics.battery.value)%"
        batteryLevel(str: ELMetrics.battery.value)
        if(ELMetrics.connected.value == "0"){dismissView()}
    }
    func batteryLevel(str : String){
        var percent = 0.0
        if(str == "100"){
            percent = 100.0
        }else if(str == "88"){
            percent = 88.0
        }else if(str == "77"){
            percent = 77.0
        }else if(str == "66"){
            percent = 66.0
        }else if(str == "55"){
            percent = 55.0
        }else if(str == "44"){
            percent = 44.0
        }else if(str == "33"){
            percent = 33.0
        }else if(str == "22"){
            percent = 22.0
        }else if(str == "11"){
            percent = 11.0
        }else{
            percent = 0.0
        }
        
        var val = percent/100.0
        val = (530-(260.0*val))
        batteryGreen.frame.origin.y = CGFloat(val)
    }
    func dismissView(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
