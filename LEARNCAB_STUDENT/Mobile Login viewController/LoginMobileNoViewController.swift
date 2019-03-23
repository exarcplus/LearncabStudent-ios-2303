//
//  LoginMobileNoViewController.swift
//  LEARNCAB_STUDENT
//
//  Created by Exarcplus on 27/03/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire
import LGSideMenuController

class LoginMobileNoViewController: UIViewController {

    @IBOutlet weak var emailtxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordtxt: SkyFloatingLabelTextField!
    var otpstr : String!
    var emailstr : String!
     @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.isHidden = true;
        let clr  = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        UIApplication.shared.statusBarView?.backgroundColor = clr
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width: 320, height: 600)
    }
    
    func validateEmail(_ candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
//        self.view.frame = CGRect(self.view.frame,0,movement)
//        //self.view.frame = CGRectOffset(self.view.frame, 0, movement)
//        UIView.commitAnimations()
    }
    
//Validation fields
    @IBAction func loginbtn(_ sender: Any) {
        
        if emailtxt.text == ""
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "Enter Your MobilNumber", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
            // self.myclass.ShowsinglebutAlertwithTitle(title: "Signup", withAlert:"Enter Your Firstname", withIdentifier:"")
        }
        else if passwordtxt.text == ""
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "Enter Your MobilNumber", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        else if emailtxt.text != ""
        {
            if !validateEmail(emailtxt.text!)
            {
                let myAlert = UIAlertController(title:"LearnCab", message: "Enter Valid Email ID", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
                return
                
            }
            else{
                print(emailtxt.text)
                print(passwordtxt.text)
                self.loginlink()
            }
        }
    }

    //login link
    func loginlink()
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
        let Login = "\(kBaseURL)student_login"
        let params:[String:String] = ["email":emailtxt.text!,"password":passwordtxt.text!,"device_id":devicetoken,"device_type":"Ios"]
        Alamofire.request(Login, method: .post, parameters: params).responseJSON { response in
            
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
                    appDelegate.SideMenu.leftViewStatusBarStyle = .lightContent
                    var rect = appDelegate.SideMenuView.view.frame;
                    rect.size.width = 240;
                    appDelegate.SideMenuView.view.frame = rect
                    appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
                    print(appDelegate.SideMenu)
                    self.present(appDelegate.SideMenu, animated:true, completion: nil)
                }
                else if res == "Check your login credentials"
                {
                    //self.emailtxt.text = ""
                    //self.passwordtxt.text = ""
                    let myAlert = UIAlertController(title:"LearnCab", message: "check your Email And Password", preferredStyle: UIAlertController.Style.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
                else if res == "Mobile Number not verified"
                {
                    let otp = dict["verification_code"] as! Int
                    self.otpstr = String(otp)
                    self.emailstr = dict["email"] as? String
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "OtpScreenViewController") as! OtpScreenViewController
                    mainview.otp = self.otpstr
                    mainview.email = self.emailstr
                    self.present(mainview, animated:true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func forgotbtn(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ForgotpwdViewController") as! ForgotpwdViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)
    }
    
    @IBAction func signupbtn(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "Signup2ViewController") as! Signup2ViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
