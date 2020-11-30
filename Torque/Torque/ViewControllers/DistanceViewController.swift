//
//  DistanceViewController.swift
//  Torque
//
//  Created by Amanuel on 8/2/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

class DistanceViewController: UIViewController {

    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var distanceNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupObservers()
        // Do any additional setup after loading the view.
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
        //determines light or dark mode
        if(ELMetrics.darkMode.value == "no"){
            view.backgroundColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
            distanceNameLbl.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        }else{
            view.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            distanceNameLbl.textColor = UIColor(red: 154/255, green: 153/255, blue: 153/255, alpha: 1)
        }
        
        distanceLbl.text = ELMetrics.distance.value
        if(ELMetrics.connected.value == "0"){dismissView()}
    }

    func dismissView(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
