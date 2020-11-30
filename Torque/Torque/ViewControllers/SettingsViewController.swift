//
//  SettingsViewController.swift
//  Torque
//
//  Created by Amanuel on 8/2/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    //label for dark/light mode
    @IBOutlet weak var settingNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var darkModeLbl: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var metImpLbl: UILabel!
    @IBOutlet weak var explainLbl: UILabel!
    @IBOutlet weak var logOutLbl: UILabel!
    @IBOutlet weak var darkField: UIImageView!
    @IBOutlet weak var darkArrow: UIImageView!
    
    //variable for textfield
    private var tempVal = ""
    
    //light color
    let lightColor1 = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    //dark color
    let darkColor1 = UIColor(red: 154/255, green: 153/255, blue: 153/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = ELMetrics.name.value
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
        //determines if lightmode/darkmode
        if(ELMetrics.darkMode.value == "no"){
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            settingNameLbl.textColor = lightColor1
            nameLbl.textColor = lightColor1
            darkModeLbl.textColor = lightColor1
            metImpLbl.textColor = lightColor1
            explainLbl.textColor = lightColor1
            logOutLbl.textColor = lightColor1
            darkField.alpha = 0;
            darkArrow.alpha = 0;
            darkModeSwitch.isOn = false
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            settingNameLbl.textColor = darkColor1
            nameLbl.textColor = darkColor1
            darkModeLbl.textColor = darkColor1
            metImpLbl.textColor = darkColor1
            explainLbl.textColor = darkColor1
            logOutLbl.textColor = darkColor1
            darkField.alpha = 1;
            darkArrow.alpha = 1;
            darkModeSwitch.isOn = true
        }
        
        if(ELMetrics.connected.value == "0"){dismissView()}
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    func dismissView(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapRecognizer(_ sender: Any) {
        view.endEditing(true)
        
    }
    @IBAction func contentChanged(_ sender: Any) {
        if(textField.text!.count == 11){
            tempVal = textField.text!
        }else if(textField.text!.count>11){
            textField.text = tempVal
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ELMetrics.name.value = textField.text!
        ELMetrics.didUpdate.value = "yes"
    }
    
    @IBAction func darkModeSwitch(_ sender: Any) {
        if(darkModeSwitch.isOn){
            ELMetrics.darkMode.value = "yes"
        }else{
            ELMetrics.darkMode.value = "no"
        }
        ELMetrics.didUpdate.value = "yes"
    }
    
    
}
