//
//  LoginViewController.swift
//  Torque
//
//  Created by Amanuel on 6/29/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var ovalImage: UIImageView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tauIcon: UILabel!
    @IBOutlet weak var darkOvalImage: UIImageView!
    //light colors
    let lightTau = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
    let lightEnter = UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1)
    //dark colors
    let darkTau = UIColor(red: 163/255, green: 163/255, blue: 163/255, alpha: 1)
    let darkEnter = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
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
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateUI), name: Notification.Name(rawValue: NotificationName.updateNotif), object: nil)
    }
    //fires when button is pressed
    @IBAction func enterButton(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        //  for home
                        //self?.performSegue(withIdentifier: "slide", sender: nil)
                        //  for test
                        self?.performSegue(withIdentifier: "toHomefromLogIn", sender: nil)
                    } else {
                        //fail
                    }
                }
            }
        } else {
            print("device doesn't have biometrics enabled/supported")
        }
        
    }
    
    //updates ui
    @objc func updateUI(){
        //determines light/dark mode
        if(ELMetrics.darkMode.value == "no"){
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            tauIcon.textColor = lightTau
            btn.setTitleColor(lightEnter, for: .normal)
            ovalImage.alpha = 1
            darkOvalImage.alpha = 0
            if(ELMetrics.connected.value == "0"){
                btn.isEnabled = true;
                btn.alpha = 0
                ovalImage.alpha = 0
            }else{
                btn.isEnabled = true
                btn.alpha = 1
                ovalImage.alpha = 1
            }
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            tauIcon.textColor = darkTau
            btn.setTitleColor(darkEnter, for: .normal)
            ovalImage.alpha = 0
            darkOvalImage.alpha = 1
            if(ELMetrics.connected.value == "0"){
                btn.isEnabled = true;
                btn.alpha = 0
                darkOvalImage.alpha = 0
            }else{
                btn.isEnabled = true
                btn.alpha = 1
                darkOvalImage.alpha = 1
            }
        }
        
    }
    
    
    
}
