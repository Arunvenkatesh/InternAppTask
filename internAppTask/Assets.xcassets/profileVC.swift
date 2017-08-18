//
//  profileVC.swift
//  internAppTask
//
//  Created by Selvam M on 15/08/17.
//  Copyright © 2017 arun. All rights reserved.
//

import UIKit

class profileVC: UIViewController {

    var emailDum:String = ""
    var nameDum:String = ""
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prname = UserDefaults.standard.string(forKey: "pname")
        let premail = UserDefaults.standard.string(forKey: "pemail")
        Name.text = prname
        email.text = premail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
