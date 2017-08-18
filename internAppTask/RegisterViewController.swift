//
//  RegisterViewController.swift
//  internAppTask
//
//  Created by Selvam M on 12/08/17.
//  Copyright © 2017 arun. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

   var emailDummy:String = ""
    var nameDummy:String = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let prname = UserDefaults.standard.string(forKey: "pname")
        
        let premail = UserDefaults.standard.string(forKey: "pemail")
        emailLabel.text = prname
        nameLabel.text = premail
        
    }

    @IBAction func registerBtnClicked(_ sender: UIButton) {
        print("button is clicked")
        
    }

}
