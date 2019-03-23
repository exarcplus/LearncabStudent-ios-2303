//
//  OtpScreenViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 06/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire
import LGSideMenuController

class OtpScreenViewController: UIViewController {

    @IBOutlet weak var pinView : SVPinView!
    var mobileno : String!
    var otp : String!
    var email : String!
    var pinstr : String!
    @IBOutlet weak var otpText : UITextField!
    @IBOutlet weak var mobileLable : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        //pinView.pinLength = 3
    print(otp)
        print(email)
       
        //otpText.text = otp
        pinView.secureCharacter = "\u{25CF}"
       // pinView.secureCharacter =
        //pinView.secureCharacter = "\u{25CF}"
        //pinView.interSpace = 3
        //pinView.textColor = UIColor.black
        //pinView.underlineColor = UIColor.black
        //pinView.underLineThickness = 2
        pinView.shouldSecureText = true
        
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .phonePad
        pinView.pinIinputAccessoryView = UIView()
        pinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
            self.pinstr = pin
            print(self.pinstr)
            if self.pinstr == self.otp
            {
                
            }
            else{
                let myAlert = UIAlertController(title:"LearnCab", message: "otp incorrect", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
            
        }
        
        print(mobileno)
        if mobileno == nil
        {
            self.mobileLable.text = ""
        }
        else
        {
           self.mobileLable.text = String(format: "which sent to +91 %@", mobileno)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitClick(_ sender: UIButton)
    {
        if pinstr == otp
        {
            self.verificationlink()
        }
        else
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "otp incorrect", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func verificationlink()
    {
        var devicetoken : String!
        if UserDefaults.standard.string(forKey: "token") == nil
        {
            devicetoken = ""
            //devicetoken = newDeviceId
        }
        else
        {
            devicetoken = UserDefaults.standard.string(forKey: "token") as String?
            //devicetoken = newDeviceId
            print(devicetoken)
        }
         let kLurl = "\(kBaseURL)check_verification_code"
        let params:[String:String] = ["email":email,"verification_code":otp,"device_id":devicetoken,"device_type":"Ios"]
        Alamofire.request(kLurl, method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)
                let res = dict["result"] as? String
                print(res as Any)
                if res == "success"
                {
                    let data = dict["data"] as? [Dictionary<String,AnyObject>]
                    print(data)
                    if let userData = data![0] as? Dictionary<String,AnyObject>{
                        print(userData)
                        UserDefaults.standard.set(userData, forKey: "Logindetail")
                    }
                    let token = dict["token"] as? String
                    print(token as Any)
                    UserDefaults.standard.set(token, forKey:"tokens")
                    UserDefaults.standard.synchronize()
//                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
//                    let nav = UINavigationController.init(rootViewController: mainview)
//                    self.present(nav, animated:true, completion: nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                    let nav = UINavigationController.init(rootViewController: mainview)
                    appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
                    appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
                    appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
                    appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
                    appDelegate.SideMenu.leftViewStatusBarStyle = .default
                    var rect = appDelegate.SideMenuView.view.frame;
                    rect.size.width = 240;
                    appDelegate.SideMenuView.view.frame = rect
                    appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
                    print(appDelegate.SideMenu)
                    self.present(appDelegate.SideMenu, animated:true, completion: nil)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     ["result": Already registered using Facebook]
    */

}
