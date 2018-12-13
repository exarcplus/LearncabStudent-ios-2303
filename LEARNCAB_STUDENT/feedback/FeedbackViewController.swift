//
//  FeedbackViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 17/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class FeedbackViewController: UIViewController {

    @IBOutlet weak var textview : UITextView!
    @IBOutlet weak var sendbtn : UIButton!
    var mesg : String!
    var tokenstr : String!
    var student_id : String!
    var myclass : MyClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         myclass = MyClass()
        self.navigationController?.navigationBar.isHidden = false
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        // print(LC_id)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            student_id = newResult["_id"] as! String
            print(student_id)
        }
        
        let borderColor = UIColor.black.cgColor
        textview.layer.borderColor = borderColor.copy(alpha: 0.1)
        textview.layer.borderWidth = 1.5;
        textview.layer.cornerRadius = 5.0;
        self.view.endEditing(true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitbutton(_ x:AnyObject)
    {
        mesg = textview.text!
        print(mesg)
        if mesg == ""
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "Please Enter Feedback.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        else
        {
           self.feedbacklink()
        }
    }
    
    @IBAction func backbtn (_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.SideMenu.showLeftView(animated: true, completionHandler: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func feedbacklink()
    {
        let params:[String:String] = ["student_id":student_id,"message":mesg]
        SVProgressHUD.show()
         let kLurl = "\(kBaseURL)send_feedback/?token="+tokenstr
        Alamofire.request(kLurl, method: .post, parameters: params).responseJSON { response in

            print(response)

            let result = response.result
            print(response)


            if let dat = result.value as? Dictionary<String,AnyObject>
            {
                let res = dat["result"] as! String
                if res == "success"
                {
                    SVProgressHUD.dismiss()
                    self.textview.text = ""
                    let myAlert = UIAlertController(title:"LearnCab", message: "Thank you for your feedback.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                   // self.myclass.ShowsinglebutAlertwithTitle(title: self.myclass.StringfromKey(Key: "LearnCab"), withAlert:self.myclass.StringfromKey(Key: "Thank you for your feedback."), withIdentifier:"Thank you for your feedback.")
                    //                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    //                    let nav = UINavigationController.init(rootViewController: mainview)
                    //                    self.present(nav, animated:true, completion: nil)
                }

            }
            else
            {
                self.myclass.ShowsinglebutAlertwithTitle(title: self.myclass.StringfromKey(Key: "LearnCab"), withAlert:self.myclass.StringfromKey(Key: "checkinternet"), withIdentifier:"internet")
                SVProgressHUD.dismiss()
            }
            SVProgressHUD.dismiss()
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
