//
//  HomeViewController.swift
//  Torque
//
//  Created by Amanuel on 6/30/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
//VARIABLE SETUP
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var speedUnit: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var batteryGreen: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    //labels to change for darkmode
    @IBOutlet weak var bLbl: UILabel!
    @IBOutlet weak var dLbl: UILabel!
    @IBOutlet weak var cLbl: UILabel!
    @IBOutlet weak var sLbl: UILabel!
    //arrows
    @IBOutlet weak var LArrow1: UIImageView!
    @IBOutlet weak var LArrow2: UIImageView!
    @IBOutlet weak var LArrow3: UIImageView!
    @IBOutlet weak var LArrow4: UIImageView!
    @IBOutlet weak var LArrow5: UIImageView!
    @IBOutlet weak var DArrow1: UIImageView!
    @IBOutlet weak var DArrow2: UIImageView!
    @IBOutlet weak var DArrow3: UIImageView!
    @IBOutlet weak var DArrow4: UIImageView!
    @IBOutlet weak var DArrow5: UIImageView!
    @IBOutlet weak var blackCover: UIImageView!
    
    //light color
    let lightColor1 = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    let lightColor2 = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
    //dark color
    let darkColor1 = UIColor(red: 154/255, green: 153/255, blue: 153/255, alpha: 1)
    
    //INITIALIZE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupObservers()

    }
    //removes notification center when view is removed
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//SETUP FOR HOME
    //setsup notification observers for this view
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.updateUI), name: Notification.Name(rawValue: NotificationName.updateNotif), object: nil)
    }

//INTERACTIVE TO USER
    //updates ui
    @objc func updateUI(){
        //sets light or dark mode
        if(ELMetrics.darkMode.value == "no"){
            //is light mode
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            nameLbl.textColor = lightColor1
            valueLbl.textColor = lightColor1
            speedLbl.textColor = lightColor1
            speedUnit.textColor = lightColor1
            bLbl.textColor = lightColor2
            dLbl.textColor = lightColor2
            cLbl.textColor = lightColor2
            sLbl.textColor = lightColor2
            LArrow1.alpha = 1
            LArrow2.alpha = 1
            LArrow3.alpha = 1
            LArrow4.alpha = 0.5
            LArrow5.alpha = 1
            DArrow1.alpha = 0
            DArrow2.alpha = 0
            DArrow3.alpha = 0
            DArrow4.alpha = 0
            DArrow5.alpha = 0
            blackCover.alpha = 0;
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            nameLbl.textColor = darkColor1
            valueLbl.textColor = darkColor1
            speedLbl.textColor = darkColor1
            speedUnit.textColor = darkColor1
            bLbl.textColor = darkColor1
            dLbl.textColor = darkColor1
            cLbl.textColor = darkColor1
            sLbl.textColor = darkColor1
            LArrow1.alpha = 0
            LArrow2.alpha = 0
            LArrow3.alpha = 0
            LArrow4.alpha = 0
            LArrow5.alpha = 0
            DArrow1.alpha = 1
            DArrow2.alpha = 1
            DArrow3.alpha = 1
            DArrow4.alpha = 0.5
            DArrow5.alpha = 1
            blackCover.alpha = 1;
        }
        //sets values according to received values
        speedLbl.text = ELMetrics.speed.value
        valueLbl.text = "\(ELMetrics.battery.value)%"
        batteryEditor(str: ELMetrics.battery.value)
        nameLbl.text = ELMetrics.name.value
        if(ELMetrics.connected.value == "0"){dismissView()}
    }
    

    //battery editor
    func batteryEditor(str:String){
        var percent : Double;
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
        
        var val = (percent*1.0)/100.0
        val = (64*val)+64
        
        batteryGreen.frame.origin.x = CGFloat(val)
    }
    
    
    func dismissView(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toBatteryView(_ sender: Any) {
        performSegue(withIdentifier: "toBattery", sender: self)
    }
    
    @IBAction func toDistanceView(_ sender: Any) {
        performSegue(withIdentifier: "toDistance", sender: self)
    }
    
    @IBAction func toControlsView(_ sender: Any) {
        performSegue(withIdentifier: "toControls", sender: self)
    }
    
    @IBAction func toSettingsView(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
}
    

