//
//  SideMenuViewController.swift
//  hello
//
//  Created by Exarcplus on 08/03/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import SDWebImage
import LGSideMenuController
import Alamofire
import SVProgressHUD

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var selectedpage:Int!
    var menuarra:NSMutableArray!
    var imgarr = NSMutableArray()
    
    @IBOutlet weak var image : UIImageView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var email : UILabel!
    @IBOutlet weak var SideList: UITableView!
    
      var tokenstr : String!
     var passuserid : String!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            let first = newResult["first_name"] as! String
            let second = newResult["last_name"] as! String
            self.name.text = first + " " + second
            self.email.text = newResult["email"] as! String
            passuserid = newResult["_id"] as! String
            print(passuserid)
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        menuarra = NSMutableArray()
        menuarra.add("MY COURSES");
        menuarra.add("LECTURES"); 
        menuarra.add("DASHBOARD");
        menuarra.add("PACKAGES");
        menuarra.add("TOPUP");
        menuarra.add("PROFILE");
        menuarra.add("FEEDBACK");
        
        
   self.imgarr = [UIImage(named: "MC.png")!, UIImage(named: "VL (1).png")!, UIImage(named: "dash1.png")!, UIImage(named: "pack1.png")!, UIImage(named: "pack1.png")!, UIImage(named: "profile.png")!, UIImage(named: "feedback.png")!]
        
        self.SideList.reloadData()
        self.SideList.separatorStyle = .none
        self.view.endEditing(true)
        if tokenstr == "" || tokenstr == nil
        {
            
        }
        else
        {
            self.profilelink()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuarra.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.selectionStyle = .none
        cell.Title.text = menuarra.object(at: indexPath.row) as? String
       cell.imgview.image = imgarr.object(at: indexPath.row) as? UIImage
            //cell.Indicator.isHidden = true
   
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
           // currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 1
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesListViewController") as! LecturesListViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 2
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 3
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 4
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "TopUpViewController") as! TopUpViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 5
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
        else if indexPath.row == 6
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                        //            let navController = UINavigationController(rootViewController: mainview)
            currentview.pushViewController(mainview, animated: false)
            //currentview.present(navController, animated: false, completion: nil)
        }
       
    }
    
    
    func profilelink()
    {
        
        let params:[String:String] = ["token":tokenstr]
        // SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_student_details1/"
        Alamofire.request(kLurl+passuserid+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)
                if let list = dict["data"] as? [Dictionary<String,AnyObject>]{
                    
                    let img = list[0]["profile_image"] as! String
                    if img == ""
                    {
                        self.image.image = UIImage.init(named: "profile_unselect.png")
                    }
                    else
                    {
                        self.image.sd_setImage(with: URL(string: img))
                    }
                }
            }
        }
    }
    
    @IBAction func logoutbutton(_sender : UIButton)
    {
        
        let uiAlert = UIAlertController(title: "LOGOUT", message: "Do you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            print("Click of default button")
            
            UserDefaults.standard.removeObject(forKey: "Logindetail")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "tokens")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "course_name")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "course_id")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "Profile")
            UserDefaults.standard.synchronize()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            UIApplication.shared.unregisterForRemoteNotifications()
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
            let nav = UINavigationController.init(rootViewController: mainview)
            self.present(nav, animated:true, completion: nil)
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        
    }

}
