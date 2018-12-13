//
//  ProfileViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 17/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import ZRScrollableTabBar
import LGSideMenuController
import SDWebImage
import Alamofire
import SVProgressHUD

class ProfileViewController: UIViewController,ZRScrollableTabBarDelegate {

    @IBOutlet weak var nameLab : UILabel!
    @IBOutlet weak var emailLab : UILabel!
    @IBOutlet weak var courseLab : UILabel!
    @IBOutlet weak var mobileLab : UILabel!
    @IBOutlet weak var addressLab : UILabel!
    @IBOutlet weak var pincodeLab : UILabel!
    @IBOutlet weak var stateLab : UILabel!
    @IBOutlet weak var cityLab : UILabel!
    @IBOutlet weak var profileimg : UIImageView!
    @IBOutlet weak var Tabbarview: UIView!
    var passuserid : String!
    var tokenstr : String!
    var fnamestr : String!
    var lnamestr : String!
    var citstr : String!
    var satestr : String!
    var addrstr : String!
    var imgstr : String!
    
    var Tabbar:ZRScrollableTabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            passuserid = newResult["_id"] as! String
            print(passuserid)

        }
        let name = UserDefaults.standard.string(forKey: "course_name")
        print(name)
        if name != nil
        {
            self.courseLab.text = (name as! String)
        }
        
        
        let item1 = UITabBarItem.init(title:"My Course", image: UIImage.init(named:"mycourseuncolor"), tag: 1)
        item1.image = UIImage.init(named: "mycourseuncolor")?.withRenderingMode(.alwaysOriginal)
        item1.selectedImage = UIImage.init(named: "mycoursecolor")?.withRenderingMode(.alwaysOriginal)
        
        let item2 = UITabBarItem.init(title:"Lectures", image: UIImage.init(named:"lectureuncolor"), tag: 2)
        item2.image = UIImage.init(named: "lectureuncolor")?.withRenderingMode(.alwaysOriginal)
        item2.selectedImage = UIImage.init(named: "lecturecolor")?.withRenderingMode(.alwaysOriginal)
        
        let item3 = UITabBarItem.init(title:"Dashboard", image: UIImage.init(named:"dashboarduncolor"), tag: 3)
        item3.image = UIImage.init(named: "dashboarduncolor")?.withRenderingMode(.alwaysOriginal)
        item3.selectedImage = UIImage.init(named: "dashboardcolor")?.withRenderingMode(.alwaysOriginal)
        
        let item4 = UITabBarItem.init(title:"Packages", image: UIImage.init(named:"packageuncolor"), tag: 4)
        item4.image = UIImage.init(named: "packageuncolor")?.withRenderingMode(.alwaysOriginal)
        item4.selectedImage = UIImage.init(named: "packgecolor")?.withRenderingMode(.alwaysOriginal)
        
        let item5 = UITabBarItem.init(title:"Profile", image: UIImage.init(named:"profileuncolor"), tag: 5)
        item5.image = UIImage.init(named: "profileuncolor")?.withRenderingMode(.alwaysOriginal)
        item5.selectedImage = UIImage.init(named:"profilecolor")?.withRenderingMode(.alwaysOriginal)
        
        Tabbar = ZRScrollableTabBar.init(items: [item1,item2,item3,item4,item5])
        //       Tabbar.tintColor =  ("#000000")
        
        Tabbar.scrollableTabBarDelegate = self;
        Tabbar.selectItem(withTag: 5)
        Tabbar.frame = CGRect(x: 0, y: 0,width: UIScreen.main.bounds.size.width, height: Tabbarview.frame.size.height);
        Tabbarview.addSubview(Tabbar)
        
       
        // Do any additional setup after loading the view.
    }
    
    func scrollableTabBar(_ tabBar: ZRScrollableTabBar!, didSelectItemWithTag tag: Int32) {
        if tag == 1
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            currentview.pushViewController(mainview, animated: false)
        }
        else if tag == 2
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesListViewController") as! LecturesListViewController
            currentview.pushViewController(mainview, animated: false)
        }
        else if tag == 3
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            currentview.pushViewController(mainview, animated: false)
        }
        else if tag == 4
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
            currentview.pushViewController(mainview, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.profilelink()
    }
    
    
    @IBAction func opensidemenu (_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SideMenu.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func editbutton (_ sender: UIButton)
    {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        let nav = UINavigationController.init(rootViewController: mainview)
        mainview.firstnamestr = self.fnamestr
        mainview.lastnamestr = self.lnamestr
        mainview.statestr = self.satestr
        mainview.citystr = self.citstr
        mainview.addressstr = self.addrstr
        mainview.vimage = self.imgstr
        self.navigationController?.pushViewController(mainview, animated: true)
    //self.present(mainview, animated:true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func profilelink()
    {
       
        let params:[String:String] = ["token":tokenstr]
         SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_student_details1/"
        Alamofire.request(kLurl+passuserid+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                print(dict)
                 if let list = dict["data"] as? [Dictionary<String,AnyObject>]{
//                    if let userData = list[0] as? Dictionary<String,AnyObject>{
//                        print(userData)
//                        UserDefaults.standard.set(userData, forKey: "Profile")
//                    }
                    self.fnamestr = list[0]["first_name"] as! String
                    self.lnamestr = list[0]["last_name"] as! String
                    self.citstr = list[0]["city"] as! String
                    self.satestr = list[0]["state"] as! String
                    self.addrstr = list[0]["address"] as! String
                    self.imgstr = list[0]["profile_image"] as! String
                    
                    let fname = list[0]["first_name"] as! String
                    let lname = list[0]["last_name"] as! String
                    let name = fname + " " + lname
                    print(name)
                    self.nameLab.text = name as! String
                    self.emailLab.text = list[0]["email"] as! String
                    self.mobileLab.text = list[0]["phone_number"] as! String
                    self.addressLab.text = list[0]["address"] as! String
                    self.pincodeLab.text = list[0]["pin_code"] as! String
                    self.stateLab.text = list[0]["state"] as! String
                    self.cityLab.text = list[0]["city"] as! String
                    let img = list[0]["profile_image"] as! String
                    if img == ""
                    {
                        self.profileimg.image = UIImage.init(named: "profile_unselect.png")
                    }
                    else
                    {
                        self.profileimg.sd_setImage(with: URL(string: img))
                    }
                }
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
