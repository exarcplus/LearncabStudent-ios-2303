//
//  LoginViewController.swift
//  hello
//
//  Created by Exarcplus on 2/14/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AFNetworking
import Alamofire
import GoogleSignIn
import LGSideMenuController
import SVProgressHUD

class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {

    var otpstr : String!
    var emailstr : String!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.isHidden = true;
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signup(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "Signup2ViewController") as! Signup2ViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)
    }
    @IBAction func emailbtn(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)
    }
    
    @IBAction func btnFBLoginPressed(sender: AnyObject)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["public_profile","email","user_friends"], handler: { (result, error) -> Void in
            if error != nil
            {
                FBSDKLoginManager().logOut()
            }
            else if (result?.isCancelled)!
            {
                NSLog("Cancelled");
                FBSDKLoginManager().logOut()
            }
            else
            {
                NSLog("Logged in");
                print(result!)
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    //fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData()
    {
        let devicetoken : String!
        if UserDefaults.standard.string(forKey: "token") == nil{
            devicetoken = ""
        }else{
            devicetoken = UserDefaults.standard.string(forKey: "token") as String?
            print(devicetoken)
        }
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, resul, error) -> Void in
                if (error == nil){
                    print(resul!)
                    var fimage = String()
                     if let dict = resul as? Dictionary<String,AnyObject>{
                        print(dict)
                        if let dat = dict["picture"] as? Dictionary<String,AnyObject>  {
                                print(dat)
                            if let data = dat["data"] as? Dictionary<String,AnyObject>  {
                                print(data)
                                fimage = data["url"] as! String
                                print(fimage)
                            }
                        }
                    }
                    let result = resul as! NSDictionary
                    let userEmail : NSString = result.value(forKey: "email") as! NSString
                    print("User Email is: \(userEmail)")
                    let fid = result.value(forKey: "id") as! NSString;
                    let fname = result.value(forKey: "first_name") as! NSString;
                    let lname = result.value(forKey: "last_name") as! NSString;
                    let devicetoken : String!
                    let params:[String:String] = ["social_media_id":fid as String,"email":userEmail as String,"type":"Facebook"]
                    Alamofire.request("http://learncab.com:3012/check_social_media_id", method: .post, parameters: params).responseJSON { response in
                        SVProgressHUD.show()
                        print(response)
                        
                        let result = response.result
                        print(response)
                        if let dict = result.value as? Dictionary<String,AnyObject>{
                            print(dict)
                            let res = dict["result"] as? String
                            print(res as Any)
                            if res == "success"{
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
                            }else if res == "new user"{
                                let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "Signup2ViewController") as! Signup2ViewController
                                mainview.firstname = fname as String
                                mainview.FB_lastname = lname as String
                                mainview.email = userEmail as String
                                mainview.type = "Facebook"
                                mainview.socialMedia_ID = fid as String
                                mainview.profile_img = fimage
                                self.present(mainview, animated:true, completion: nil)
                            }else if res == "Already registered using Email ID"{
                                let myAlert = UIAlertController(title:"LearnCab", message: "Already registered using Email ID", preferredStyle: UIAlertController.Style.alert)
                                
                                let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                                
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                                return
                            }else if res == "Mobile Number not verified"{
                                let otp = dict["verification_code"] as! Int
                                self.otpstr = String(otp)
                                self.emailstr = dict["email"] as! String
                                let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "OtpScreenViewController") as! OtpScreenViewController
                                mainview.otp = self.otpstr
                                mainview.email = self.emailstr
                                self.present(mainview, animated:true, completion: nil)
                            }
                        }
                        SVProgressHUD.dismiss()
                    }

                }
            })
        }
    }
    
    @IBAction func googlePlusButtonTouchUpInside(sender: AnyObject)
    {
        let signIn = GIDSignIn.sharedInstance()
        signIn?.shouldFetchBasicProfile = true
        signIn?.delegate =  self
        signIn?.uiDelegate = self
        signIn?.signOut()
        signIn?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error != nil){
            
        }else{
            let person = GIDSignIn.sharedInstance().currentUser
            print(person!)
            print(person!.profile.name)
            
            if (person?.authentication == nil){
                
            }else{
                var devicetoken : String!
                if UserDefaults.standard.string(forKey: "token") == nil{
                    devicetoken = ""
                }else{
                    devicetoken = UserDefaults.standard.string(forKey: "token") as String?
                    //devicetoken = newDeviceId
                    print(devicetoken)
                }
                
                let nsmutdic = NSMutableDictionary()
                nsmutdic.setObject("GooglePlus", forKey:"Rtype" as NSCopying);
                nsmutdic.setObject(person!.profile.name, forKey:"Name" as NSCopying);
                nsmutdic.setObject(GIDSignIn.sharedInstance().currentUser.profile.email, forKey:"Email" as NSCopying);
                nsmutdic.setObject(String(format:"%@",person!.userID), forKey:"Sid" as NSCopying);
                nsmutdic.setObject("Male", forKey: "Gender" as NSCopying);
                
                let dimension = round(200 * UIScreen.main.scale)
                nsmutdic.setObject(String(format:"%@",(person?.profile.imageURL(withDimension: UInt(dimension)).absoluteString)!), forKey: "Image" as NSCopying);
                if person?.profile.imageURL(withDimension: UInt(dimension)).absoluteString == nil{
                    let profile_pic = "";
                    nsmutdic.setObject(profile_pic, forKey:"Pimage" as NSCopying);
                }else{
                    let profile_pic = person?.profile.imageURL(withDimension: UInt(dimension)).absoluteString
                    nsmutdic.setObject(profile_pic!, forKey:"Pimage" as NSCopying);
                }
                print(nsmutdic)
                let img = nsmutdic.value(forKey: "Pimage") as! String
                print(img)
                print(GIDSignIn.sharedInstance().currentUser.profile.email)
                
                let params:[String:String] = ["social_media_id":person!.userID as String,"email":GIDSignIn.sharedInstance().currentUser.profile.email as String,"type":"GooglePlus"]
                Alamofire.request("http://learncab.com:3012/check_social_media_id", method: .post, parameters: params).responseJSON { response in
                    SVProgressHUD.show()
                    print(response)
                    
                    let result = response.result
                    print(response)
                    if let dict = result.value as? Dictionary<String,AnyObject>{
                        print(dict)
                        let res = dict["result"] as? String
                        print(res as Any)
                       
                        if res == "success"{
                            let data = dict["data"] as? [Dictionary<String,AnyObject>]
                            if let userData = data![0] as? Dictionary<String,AnyObject>{
                                print(userData)
                                UserDefaults.standard.set(userData, forKey: "Logindetail")
                            }
                            let token = dict["token"] as? String
                            UserDefaults.standard.set(token, forKey:"tokens")
                            UserDefaults.standard.synchronize()
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
                            self.present(appDelegate.SideMenu, animated:true, completion: nil)
                        }else if res == "new user"{
                            let name = nsmutdic.value(forKey: "Name") as! String
                            print(name)
                            var myStringArr = name.components(separatedBy: " ")
                            let Firststr: String = myStringArr [0]
                            let laststr: String = myStringArr [1]
                            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "Signup2ViewController") as! Signup2ViewController
                            mainview.firstname = Firststr
                            mainview.FB_lastname = laststr
                            mainview.email = nsmutdic.value(forKey: "Email") as! String
                            mainview.type = "GooglePlus"
                            mainview.socialMedia_ID = nsmutdic.value(forKey: "Sid") as! String
                            mainview.profile_img = nsmutdic.value(forKey: "Pimage") as! String
                            mainview.deviceId = devicetoken as String
                            self.present(mainview, animated:true, completion: nil)
                        }else if res == "Already registered using Email ID"{
                            let myAlert = UIAlertController(title:"LearnCab", message: "Already registered using Email ID", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                            return
                        }else if res == "Mobile Number not verified"{
                            let otp = dict["verification_code"] as! Int
                            self.otpstr = String(otp)
                            self.emailstr = dict["email"] as? String
                            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "OtpScreenViewController") as! OtpScreenViewController
                            mainview.otp = self.otpstr
                            mainview.email = self.emailstr
                            self.present(mainview, animated:true, completion: nil)
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



