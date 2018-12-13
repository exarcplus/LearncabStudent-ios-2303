//
//  ForgotpwdViewController.swift
//  hello
//
//  Created by Exarcplus on 22/02/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire

class ForgotpwdViewController: UIViewController {

    @IBOutlet weak var email_text: SkyFloatingLabelTextField!
     @IBOutlet weak var sendbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
        colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
         UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateEmail(_ candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    @IBAction func backbutton(_sender: UIButton)
    {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
        //let nav = UINavigationController.init(rootViewController: mainview)
        self.navigationController?.pushViewController(mainview, animated:true)
    }
    
    @IBAction func sendbutton(_sender: UIButton)
    {
        if email_text.text == ""
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "Enter Valid Email ID", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        else if email_text.text != ""
        {
            if !validateEmail(email_text.text!)
            {
                let myAlert = UIAlertController(title:"LearnCab", message: "Enter Valid Email ID", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
                return
                
            }
            else{
                self.sendlink()
            }
        }
        
    }
    func sendlink()
    {
         let kLurl = "\(kBaseURL)forgot_password"
        let params:[String:String] = ["email":email_text.text!]
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
                    let myAlert = UIAlertController(title:"LearnCab", message: "Please check your email for reset password", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
                else if res == "failed"
                {
                    let myAlert = UIAlertController(title:"LearnCab", message: "Enter your registerd email id", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
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
    */

}
extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
