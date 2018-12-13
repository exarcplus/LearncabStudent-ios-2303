//
//  RazorpayViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 21/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Razorpay
class RazorpayViewController: UIViewController,RazorpayPaymentCompletionProtocol {

    @IBOutlet weak var Paybtn : UIButton!
     @IBOutlet weak var canclebtn : UIButton!
    @IBOutlet weak var amountlab : UILabel!
    @IBOutlet weak var packagelab : UILabel!
    
    var tokenstr : String!
    var student_id : String!
    var amount : String!
    var tax : String!
    var phoneno : String!
    var email : String!
    var namestr :String!
    var detailsdic : NSDictionary!
    var razorpay : Razorpay!
    var gstamount : Double!
    var paymentid :String!
    var program_id : String!
    var errormsg : String!
    var totalamount : String!
    var packagetitle : String!
    var courseid : String!
    var package_id : String!
    var course_name : String!
    var sub_courseid : String!
    var titlestr : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            student_id = newResult["_id"] as! String
            print(student_id)
            let fname = newResult["first_name"] as! String
            let lname = newResult["last_name"] as! String
            let name = fname + " " + lname
            print(name)
            namestr = name as! String
            email = newResult["email"] as! String
            phoneno = newResult["phone_number"] as! String
        }
        
        if amount == nil || amount == ""
        {
           amountlab.text = ""
        }
        else
        {
            amountlab.text = String(format: "Rs. %@/-", amount!)
        }
        
        self.packagelab.text = self.packagetitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func paybtn (_ sender: UIButton)
    {
       self.paylink()
    }
    
    @IBAction func cancelbtn (_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    //Razorpay Payment
    func paylink()
    {
        let res : Double = (Double(amount)! / 100.0) * Double(tax)!
        print(res)
        let total : Double = Double(amount)! 
        print(total)
        let totalAmount : Double = total * 100.0
        print(totalAmount)
        totalamount = String(amount)
        gstamount = totalAmount
        razorpay = Razorpay.initWithKey("rzp_live_7wwYuQPI9JsCs6", andDelegate: self)
//        razorpay = Razorpay.initWithKey("rzp_test_XFOs7v57MaFWvW", andDelegate: self)
        self.showPaymentForm()
    }
    
    
    func showPaymentForm() {
        //let img = UIImage.init(named: "studenticon.png")
        let options = [
            "amount" : gstamount,
            "name" : namestr,
            //"image" : img,
            "prefill" : [
                "email" : email,
                "contact" : phoneno
            ],
            "theme": [
                "color": "#339933"
            ]
            ] as [String : Any]
        razorpay.open(options)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        UIAlertView.init(title: "Payment Successful", message: payment_id, delegate: self, cancelButtonTitle: "OK").show()
        paymentid = payment_id
        if titlestr == "Topup"
        {
            self.paymentUpdate()
        }
        else{
            self.paymentUpdatelink()
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        UIAlertView.init(title: "Error", message: str, delegate: self, cancelButtonTitle: "OK").show()
        errormsg = str
         //self.dismiss(animated: true)
        //self.errorlink()
    }
    
    
    func paymentUpdatelink()
    {
        print(tokenstr)
        print(paymentid)
        print(courseid)
        print(sub_courseid)
        print(totalamount)
        print(student_id)
        print(package_id)
        
        let params:[String:String] = ["payment_id":paymentid,"course_id":courseid,"course_level_id":self.sub_courseid,"package_id":package_id,"amount":totalamount,"student_id":student_id]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)store_student_package/?token="
        Alamofire.request(kLurl+tokenstr+"", method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
                    appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
                    currentview.pushViewController(mainview, animated: false)
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    
    func paymentUpdate()
    {
        print(tokenstr)
        print(paymentid)
        print(courseid)
        print(sub_courseid)
        print(totalamount)
        print(student_id)
        print(package_id)
        
        let params:[String:String] = ["payment_id":paymentid,"course_id":courseid,"course_level_id":self.sub_courseid,"topup_id":package_id,"amount":totalamount,"student_id":student_id]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)store_student_topup/?token="
        Alamofire.request(kLurl+tokenstr+"", method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "TopUpViewController") as! TopUpViewController
                    self.navigationController?.pushViewController(mainview, animated: true)
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    @IBAction func backbtn (_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }

}
