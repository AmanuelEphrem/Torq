//
//  ControlsViewController.swift
//  Torque
//
//  Created by Amanuel on 8/2/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController {
    //outlets for darkmode/lightmode
    @IBOutlet weak var controlNameLbl: UILabel!
    @IBOutlet weak var speedModeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var aproxSpeedLbl: UILabel!
    @IBOutlet weak var buzzBuzzLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    //light color
    let lightColor1 = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    //dark color
    let darkColor1 = UIColor(red: 154/255, green: 153/255, blue: 153/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupObservers()
    }
    //removes notifications
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //setsup notification observers for this view
    func setupObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.updateUI), name: Notification.Name(rawValue: NotificationName.updateNotif), object: nil)
    }
    
    //updates ui
    @objc func updateUI(){
        //forces slider in one location
        slider.value = 14
        //determines light or dark mode
        if(ELMetrics.darkMode.value == "no"){
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            controlNameLbl.textColor = lightColor1
            speedModeLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            ratingLbl.textColor = lightColor1
            aproxSpeedLbl.textColor = lightColor1
            buzzBuzzLbl.textColor = lightColor1
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            controlNameLbl.textColor = darkColor1
            speedModeLbl.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            ratingLbl.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            aproxSpeedLbl.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            buzzBuzzLbl.textColor = darkColor1
        }
        
        if(ELMetrics.connected.value == "0"){dismissView()}
    }
    
    //updates info sent to el
    @IBAction func touchDown(_ sender: Any) {
        ELMetrics.onOrOff.value = "55"
    }
    
    @IBAction func touchUp(_ sender: Any) {
        ELMetrics.onOrOff.value = "45"
    }
    
    func dismissView(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    

}
