//
//  Signup2ViewController.swift
//  hello
//
//  Created by Exarcplus on 23/02/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import LGSideMenuController
import AFNetworking
import ActionSheetPicker_3_0
import Alamofire
import SVProgressHUD

class Signup2ViewController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet weak var pickercourse: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var usernametxt: SkyFloatingLabelTextField!
    @IBOutlet weak var emailtxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordtxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmpasswordtxt: SkyFloatingLabelTextField!
    @IBOutlet weak var mobiletxt: SkyFloatingLabelTextField!
    @IBOutlet weak var lastname: SkyFloatingLabelTextField!
    @IBOutlet weak var pincode: SkyFloatingLabelTextField!
     @IBOutlet weak var scrollView: UIScrollView!
    
    var detailarr = [Dictionary<String,AnyObject>]()
    var locationid : String!
    var locationarr = NSMutableArray()
    var courseid : String!
    var coursarr : String!
    var myclass : MyClass!
    let limitLength = 10
    var detaarr = [String]()
    var idarr = [String]()
    var firstname : String!
    var FB_lastname : String!
    var type : String!
    var email : String!
    var socialMedia_ID : String!
    var profile_img : String!
    var deviceId : String!
    var mobilenumberstr : String!
    
    var otpstr : String!
    var emailstr : String!
   override func viewDidLoad()
   {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        myclass = MyClass()
        self.view.endEditing(true)
        if type == "Facebook"
        {
            usernametxt.text = firstname
            lastname.text = FB_lastname
            emailtxt.text = email
            passwordtxt.isHidden = true
            confirmpasswordtxt.isHidden = true
        }
        else if type == "GooglePlus"
        {
            usernametxt.text = firstname
            lastname.text = FB_lastname
            emailtxt.text = email
            passwordtxt.isHidden = true
            confirmpasswordtxt.isHidden = true
        }
        else
        {
            passwordtxt.isHidden = false
            confirmpasswordtxt.isHidden = false
        }
        self.intiallink()
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
      //  scrollView.contentSize = CGSize(width: 320, height: 600)
    }
    
    @IBAction func course_clicked(_ sender: UIButton)
    {
               //self.view.endEditing(true)
            ActionSheetStringPicker.show(withTitle: "Please select the course", rows: detaarr , initialSelection: 1,doneBlock: {
            picker, value, index in
            self.pickercourse.placeholder = ""
            self.pickercourse.text = index as? String
            let index = self.detaarr.index(of: self.pickercourse.text!)
            print(index)
            self.courseid = self.idarr[index!] as! String
            print(self.courseid)
            print("value = \(value)")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            return
                }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func back_clicked(_ sender: UIButton) {
//        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
//        let nav = UINavigationController.init(rootViewController: mainview)
//        self.present(nav, animated:true, completion: nil)
        self.dismiss(animated: true)
        
    }

    

    
    func intiallink()
    {
        //let params:[String:String] = [ ]
        let Login = "\(kBaseURL)students_course"
        SVProgressHUD.show()
        Alamofire.request(Login, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
            if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
            self.detailarr = list
            print(self.detailarr)
            if self.detailarr.count != 0
            {
               
                for c in 0 ..< self.detailarr.count
                {
                    let course = self.detailarr[c]["course_name"] as! String
                    self.detaarr.append(course)
                    let idstr = self.detailarr[c]["course_id"] as! String
                    self.idarr.append(idstr)
                    print(self.detaarr)
                }
                    }
            }
        }
            SVProgressHUD.dismiss()
            
        }
    }
                    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }
   

    func validateEmail(_ candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
   
   


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = mobiletxt.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    

  @IBAction func button_Submit(_ sender: Any) {
    self.view.endEditing(true)
    let spain = passwordtxt.text
    print(spain)
    
    print(spain?.count)
    if type == "Facebook"
    {
        print(usernametxt.text)
        print(lastname.text)
        print(emailtxt.text)
        print(mobiletxt.text)
        print(passwordtxt.text)
        print(courseid)
        self.signuplink()
    }
    else if type == "GooglePlus"
    {
        print(usernametxt.text)
        print(lastname.text)
        print(emailtxt.text)
        print(mobiletxt.text)
        print(passwordtxt.text)
        print(courseid)
        print(profile_img)
        print(socialMedia_ID)
        print(type)
        self.signuplink()
    }
    else
    {
    if usernametxt.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Firstname", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
       // self.myclass.ShowsinglebutAlertwithTitle(title: "Signup", withAlert:"Enter Your Firstname", withIdentifier:"")
    }
    else if lastname.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Lastname", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
       
    }
    else if emailtxt.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Email", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
        
    }
    else if mobiletxt.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Mobile Number", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
        
    }
    else if passwordtxt.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Password", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
        
    }
    else if (spain?.count)! < 6
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter minimum 6 Character", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
    }
    else if confirmpasswordtxt.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your Confirm Password", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
      
    }
    else if pickercourse.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Select Course", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
        
    }
    else if pincode.text == ""
    {
        let myAlert = UIAlertController(title:"Signup", message: "Enter Your PinCode", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        return
        
    }
    else
    {
        if emailtxt.text != ""
        {
            if !validateEmail(emailtxt.text!)
            {
                let myAlert = UIAlertController(title:"Signup", message: "Enter Valid Email ID", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
                return
               
            }
            else if passwordtxt.text != confirmpasswordtxt.text
            {
                let myAlert = UIAlertController(title:"Signup", message: "Your Password and Confirm Password does not match", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
                return
               
            }
            else
            {
                print(usernametxt.text)
                print(lastname.text)
                print(emailtxt.text)
                print(mobiletxt.text)
                print(passwordtxt.text)
                print(courseid)
                print(pincode.text)
                profile_img = ""
                socialMedia_ID = ""
                type = ""
                self.signuplink()
            }
        }
    }
    }
}
    
    func signuplink()
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
        let kLurl = "\(kBaseURL)student_signup"
        let params:[String:String] = ["first_name":usernametxt.text!,"last_name":lastname.text!, "email":emailtxt.text!, "phone_number":mobiletxt.text!, "password":passwordtxt.text!, "package_id":"", "course_id":courseid,"device_type":"Ios","profile_image":profile_img,"social_media_id":socialMedia_ID,"pin_code":pincode.text!,"type":type,"device_id":devicetoken]
        Alamofire.request(kLurl, method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)
//                let otpstr = dict["verification_code"] as? String
//                let emailstr = dict["email"] as? String
                let res = dict["result"] as? String
                print(res as Any)
                if res == "success"
                {
                    self.mobilenumberstr = self.mobiletxt.text!
                    let otp = dict["verification_code"] as! Int
                    self.otpstr = String(otp)
                    self.emailstr = dict["email"] as? String
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "OtpScreenViewController") as! OtpScreenViewController
                    mainview.otp = self.otpstr
                    mainview.email = self.emailstr
                    mainview.mobileno = self.mobilenumberstr
                    self.present(mainview, animated:true, completion: nil)
                }
                else if res == "check your email"
                {
                    self.view.endEditing(true)
                    let myAlert = UIAlertController(title:"Signup", message: "Your Email ID Already Registered.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
                else if res == "check your phone"
                {
//                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "OtpScreenViewController") as! OtpScreenViewController
//                    let nav = UINavigationController.init(rootViewController: mainview)
//                    self.present(nav, animated:true, completion: nil)
                    //self.view.endEditing(true)
                    let myAlert = UIAlertController(title:"Signup", message: "check your phone.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
            }
            
        }
    }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                let nav = UINavigationController.init(rootViewController: mainview)
//                appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
//                appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle:.slideAbove, alwaysVisibleOptions:[])
//                appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
//
//                appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
//                //appDelegate.SideMenu.leftViewAlwaysVisibleOptions = .onAll
//                appDelegate.SideMenu.leftViewStatusBarStyle = .default
//                var rect = appDelegate.SideMenuView.view.frame;
//                rect.size.width = 240;
//                appDelegate.SideMenuView.view.frame = rect
//                appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
//                print(appDelegate.SideMenu)
//                self.present(appDelegate.SideMenu, animated:true, completion: nil)
//
//
//
//    }
    
}
