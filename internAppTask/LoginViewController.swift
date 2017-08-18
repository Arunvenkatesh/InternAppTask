//
//  LoginViewController.swift
//  shortfundly
//
//  Created by Selvam M on 01/08/17.
//  Copyright © 2017 arun. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    var fname: String = ""
    var lname: String = ""
    var femail: String = ""
     var fbLoginButton: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button}()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
            print(token)
        }
       
self.view.addSubview(fbLoginButton)
        fbLoginButton.frame =  CGRect(x: 105, y: 510.5, width: 200, height: 30)
        
    }
     var fbr = [fbassert]()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func fetchProfile()
    {
        print("Fetch Profile printed")
        let params = ["fields": "email, first_name, last_name, picture.type(large),birthday"]
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let datar:[String:AnyObject] = result as! [String : AnyObject]
                 self.fname = (datar["first_name"] as? String)!
                 self.lname = (datar["last_name"] as? String)!
                 self.femail = (datar["email"] as? String)!
                print("=====================\(datar)==========================")
                print("\(String(describing: self.fname))+\(String(describing: self.femail))")
                self.fbr.append(fbassert(fname: self.fname , lname: self.lname , femail: self.femail ))
                
            }
        })
        
    }
    
    
       
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed Login")
        
        fetchProfile()
             let defaults = UserDefaults.standard
            defaults.set(femail, forKey: "pemail")
            defaults.set(fname+lname, forKey: "pname")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
       // nextViewController.emailDummy = femail
       // nextViewController.nameDummy = fname+lname
        
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("completed Logout")
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}
