//
//  LecturesListViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 31/05/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import ZRScrollableTabBar
import LGSideMenuController
import Alamofire
import SVProgressHUD
import KGModal
class LecturesListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,ZRScrollableTabBarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var collectionview : UICollectionView!
    @IBOutlet weak var listtable : UITableView!
    @IBOutlet weak var  datelab : UILabel!
    @IBOutlet weak var  emptylab : UILabel!
    var Tabbar:ZRScrollableTabBar!
    @IBOutlet weak var Tabbarview: UIView!
     var datearr = [Date]()
    var bookDate = [Date]()
    var collectionindex : Int!
    var tokenstr : String!
    var student_id : String!
    var listarr = [Dictionary<String,AnyObject>]()
    var currentdate : String!
    var datestr : String!
    var sponser : CreditPopup!
    var lcid : String!
    var lcCredit : String!
    var LC_course : String!
    var LC_chapter : String!
     var enddate : String!
    var chaptername : String!
    var sponser1 : AlertPopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        collectionindex = 0
        
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            student_id = newResult["_id"] as! String
            print(student_id)
        }
        
        let i = navigationController?.viewControllers.index(of: self)
        UserDefaults.standard.set(i, forKey:"nav")
        UserDefaults.standard.synchronize()
        
//        if self.listarr.isEmpty
//        {
//            self.emptylab.isHidden = false
//        }
//        else
//        {
            self.emptylab.isHidden = true
//        }
        
        let date = NSDate()
        print(date)
        let day = 24*3600;
        let numda = day*(365*5);
        let chagformater = DateFormatter();
        chagformater.dateFormat = "MMMM"
        let tstr = chagformater.string(from: date as Date)
        
        var dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        dFormatter.locale = Locale(identifier: "en_US_POSIX")
        dFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let tst = dFormatter.string(from:date as Date)
        currentdate = tst
        self.datestr = currentdate
        self.datelab.text = tstr
        let todate = chagformater.date(from: tstr);
        
        
        for day in (-14...0).reversed() {
            self.datearr.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            print(self.datearr)

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
        Tabbar.selectItem(withTag: 2)
        Tabbar.frame = CGRect(x: 0, y: 0,width: UIScreen.main.bounds.size.width, height: Tabbarview.frame.size.height);
        Tabbarview.addSubview(Tabbar)
        
        listtable.rowHeight = UITableViewAutomaticDimension
        listtable.estimatedRowHeight = 160
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        self.lecturehistorylink()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        else if tag == 5
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            currentview.pushViewController(mainview, animated: false)
        }
    }
    
    @IBAction func opensidemenu (_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SideMenu.showLeftView(animated: true, completionHandler: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return datearr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        //self.collectionheight.constant = self.collectionview.contentSize.height
        
        
        let dt = datearr[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dtstr = formatter.string(from: dt)
        print(dtstr)
        cell.datelab.text = dtstr
        
        let dtformatter = DateFormatter()
        dtformatter.dateFormat = "EEE"
        let daystr = dtformatter.string(from: dt)
        print(daystr)
        cell.dayLab.text = daystr
        
        let mtformatter = DateFormatter()
        mtformatter.dateFormat = "MMM"
        let monthstr = mtformatter.string(from: dt)
        print(monthstr)
        cell.monthlab.text = monthstr
        
        let datestring = datearr[indexPath.row]
        print(datestring)
        
        var dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        dFormatter.locale = Locale(identifier: "en_US_POSIX")
        dFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let tstr = dFormatter.string(from: datestring)
        let tdate = dFormatter.date(from: tstr)
        print(tdate)
        print(bookDate)
        if bookDate.contains(tdate!)
        {
            cell.datelab.backgroundColor = UIColor(red: 110/255, green: 181/255.0, blue: 42/255.0, alpha: 1.0)
            cell.datelab.textColor = UIColor.white
            cell.monthlab.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.dayLab.font = UIFont.boldSystemFont(ofSize: 12.0)
//            cell.monthlab.textColor = UIColor(red: 110/255, green: 181/255.0, blue: 42/255.0, alpha: 1.0)
//            cell.dayLab.textColor = UIColor(red: 110/255, green: 181/255.0, blue: 42/255.0, alpha: 1.0)
        }
        else
        {
            cell.datelab.backgroundColor = UIColor.white
            cell.datelab.textColor = UIColor.black
            cell.dayLab.font = UIFont.systemFont(ofSize: 12.0)
            cell.monthlab.font = UIFont.systemFont(ofSize: 12.0)
            cell.monthlab.textColor = UIColor(red: 200/255, green:200/255.0, blue: 200/255.0, alpha: 1.0)
            cell.dayLab.textColor = UIColor(red: 0/255, green: 64/255.0, blue: 128/255.0, alpha: 1.0)
        }
        if currentdate == tstr
        {
            cell.datelab.backgroundColor = UIColor(red: 51/255, green:153/255.0, blue: 51/255.0, alpha: 1.0)
            cell.datelab.textColor = UIColor.white
            cell.underlinelab.isHidden = false
        }
        else{
            cell.datelab.backgroundColor = UIColor.white
            cell.datelab.textColor = UIColor.black
            cell.dayLab.font = UIFont.systemFont(ofSize: 12.0)
            cell.monthlab.font = UIFont.systemFont(ofSize: 12.0)
            cell.monthlab.textColor = UIColor(red: 200/255, green:200/255.0, blue: 200/255.0, alpha: 1.0)
            cell.dayLab.textColor = UIColor(red: 0/255, green: 64/255.0, blue: 128/255.0, alpha: 1.0)
             cell.underlinelab.isHidden = true
        }
        if indexPath.item == collectionindex
        {
            cell.datelab.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
            cell.datelab.textColor = UIColor.white
            cell.underlinelab.isHidden = false
        }
        else
        {
            cell.underlinelab.isHidden = true
        }
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.bookDate.removeAll()
        collectionindex = indexPath.item
        self.collectionview.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        self.collectionview.reloadData()
        let datestring = datearr[indexPath.row]
        print(datestring)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let tstr = dateFormatter.string(from: datestring)
        print(tstr)
        datestr = tstr
        let todate = dateFormatter.date(from: tstr)
        print(todate)
        self.bookDate.append(todate!)
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let dateString = dateFormatter.string(from: todate!)
//        let results = someArray.filter { ($0["dateEnd"] ?? "") > dateString }
//
//        let dtFormatter = DateFormatter()
//        dtFormatter.dateFormat = "dd-MMM-yyyy"
//        let dtstr = dtFormatter.string(from: todate!)
//        datelab.text = dtstr
//        sdate = tstr
//        print(sdate)
        self.lecturehistorylink()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listarr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesListTableViewCell", for: indexPath) as! LecturesListTableViewCell
        cell.selectionStyle = .none
       
        cell.lecturename.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        cell.lecturename.numberOfLines = 0
        cell.lecturename.text = self.listarr[indexPath.row]["lecture_title"] as! String
        
        let datetime = Date()
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = "yyyy-MM-dd HH:mm"
        let currentdate = dateFormatt.string(from: datetime)
        print(currentdate)
       
        
        let enddt = self.listarr[indexPath.row]["created"] as! String
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date: Date? = dateFormatter.date(from: enddt)!
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        cell.timelab.text = dateString
        
        let endt = self.listarr[indexPath.row]["expiry_date"] as! String
        if endt == ""
        {
            cell.expairdlab.text = ""
        }
        else
        {
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date: Date? = dateFormatter.date(from: endt)!
            dateFormatter.dateFormat = "d MMM yyyy h:mm a"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date!)
            print("EXACT_DATE : \(dateString)")
            print(currentdate)
            let dFormatt = DateFormatter()
            dFormatt.dateFormat = "yyyy-MM-dd HH:mm"
            let dString = dFormatt.string(from: date!)
            print("DATE : \(dString)")
            if currentdate < dString
            {
                cell.expairdlab.text = "Expires on : \(dateString)"
            }
            else
            {
                cell.expairdlab.text = ""
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let datetime = Date()
            let dateFormatt = DateFormatter()
            dateFormatt.dateFormat = "yyyy-MM-dd HH:mm"
         //dateFormatt.dateFormat = "d MMM yyyy h:mm a"
            let currentdate = dateFormatt.string(from: datetime)
            print(currentdate)
            
            
            let enddt = self.listarr[indexPath.row]["expiry_date"] as! String
            print(enddt)
            if enddt == ""
            {
                sponser = Bundle.main.loadNibNamed("CreditPopup", owner: self, options: nil)?[0] as! CreditPopup
                //            sponser.layer.zPosition = 2
                sponser.layer.cornerRadius = 5.0
                sponser.layer.masksToBounds = true
                KGModal.sharedInstance().show(withContentView: sponser, andAnimated: true)
                KGModal.sharedInstance().tapOutsideToDismiss = false
                //print(booklistarr.count)
                sponser.okbtn.tag = indexPath.row + 123
                sponser.cancle.addTarget(self, action: #selector(LecturesDetailsViewController.closebutton(sender:)), for: UIControlEvents.touchUpInside)
                sponser.okbtn.addTarget(self, action: #selector(LecturesDetailsViewController.okbutton(sender:)), for: UIControlEvents.touchUpInside)
            }
            else
            {
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date: Date? = dateFormatter.date(from: enddt)!
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.locale = tempLocale // reset the locale
                var dateString = dateFormatter.string(from: date!)
                print("EXACT_DATE : \(dateString)")
                self.enddate = dateString
                print(currentdate)
                if currentdate < dateString
                {
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
                    mainview.course_id = self.listarr[indexPath.row]["course_id"] as! String
                    mainview.chapter_id = self.listarr[indexPath.row]["chapter_id"] as! String
                    mainview.Lecture_idstr = self.listarr[indexPath.row]["lecture_id"] as! String
                     mainview.navclas = "List"
                    mainview.chaptername = self.listarr[indexPath.row]["chapter_name"] as! String
                    self.navigationController?.pushViewController(mainview, animated: true)
                    //self.present(mainview, animated:true, completion: nil)
                }
                else
                {
                    sponser = Bundle.main.loadNibNamed("CreditPopup", owner: self, options: nil)?[0] as! CreditPopup
                    //            sponser.layer.zPosition = 2
                    sponser.layer.cornerRadius = 5.0
                    sponser.layer.masksToBounds = true
                    KGModal.sharedInstance().show(withContentView: sponser, andAnimated: true)
                    KGModal.sharedInstance().tapOutsideToDismiss = false
                    //print(booklistarr.count)
                    sponser.okbtn.tag = indexPath.row + 123
                    sponser.cancle.addTarget(self, action: #selector(LecturesDetailsViewController.closebutton(sender:)), for: UIControlEvents.touchUpInside)
                    sponser.okbtn.addTarget(self, action: #selector(LecturesDetailsViewController.okbutton(sender:)), for: UIControlEvents.touchUpInside)
                }
            }
    }
    
    
    @objc func okbutton(sender:UIButton!)
    {
        sponser.okbtn.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser.okbtn.setTitleColor(UIColor.white, for: .normal)
        KGModal.sharedInstance().hide(animated: true)
        print(listarr)
        self.lcid = self.listarr[sender.tag-123]["lecture_id"] as! String
        self.lcCredit = self.listarr[sender.tag-123]["lecture_credit"] as! String
        self.LC_course = self.listarr[sender.tag-123]["course_id"] as! String
        self.LC_chapter = self.listarr[sender.tag-123]["chapter_id"] as! String
        self.chaptername = self.listarr[sender.tag-123]["chapter_name"] as! String
        self.creditlink()
        
    }
    @objc func closebutton(sender:UIButton!)
    {
        sponser.cancle.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser.cancle.setTitleColor(UIColor.white, for: .normal)
        KGModal.sharedInstance().hide(animated: true)
    }
    
    //Lecture list
    func lecturelink()
    {
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_lectures_viewed/?token="
        Alamofire.request(kLurl+tokenstr+"&lc_student_id="+student_id, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
             self.listarr.removeAll()
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)
                    if self.listarr.count != 0
                    {
                        self.listtable.reloadData()
                    }
                }
            }
            SVProgressHUD.dismiss()
            
        }
        SVProgressHUD.dismiss()
    }
    
    //Lecture historylink
    func lecturehistorylink()
    {
        print(datestr)
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_lectures_viewed_datewise/\(datestr+"/?token=")"
        Alamofire.request(kLurl+tokenstr+"&lc_student_id="+student_id, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
            self.listarr.removeAll()
            
            let result = response.result
            print(response)
        
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)
                    if self.listarr.isEmpty
                    {
                         self.emptylab.isHidden = false
                        self.listtable.reloadData()
                    }
                   else
                    {
                         self.emptylab.isHidden = true
                        self.listtable.reloadData()
                    }
                }
            }
            SVProgressHUD.dismiss()
            
        }
        SVProgressHUD.dismiss()
    }
    
    
//    //credit link
//    func creditlink()
//    {
//        print(lcid)
//        print(lcCredit)
//        print(LC_course)
//        print(LC_chapter)
//        let params:[String:String] = ["lecture_id":lcid,"lecture_credit":lcCredit,"course_id":LC_course,"chapter_id":LC_chapter]
//        SVProgressHUD.show()
//         let kLurl = "\(kBaseURL)deduct_credit_for_lectures/?token="
//        Alamofire.request(kLurl+tokenstr+"&student_id="+student_id, method: .post, parameters: params).responseJSON { response in
//
//            print(response)
//
//            let result = response.result
//            print(response)
//            if let dat = result.value as? Dictionary<String,AnyObject>{
//                let res = dat["result"] as! String
//                if res == "success"
//                {
//                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
//                    mainview.course_id = self.LC_course
//                    mainview.chapter_id = self.LC_chapter
//                    mainview.Lecture_idstr = self.lcid
////                    mainview.lecturelistarr = self.lecturearr
//                    mainview.chaptername = self.chaptername
//                    self.navigationController?.pushViewController(mainview, animated: true)
//                    //self.present(mainview, animated:true, completion: nil)
//                }
//
//            }
//            SVProgressHUD.dismiss()
//
//        }
//        //SVProgressHUD.dismiss()
//    }
    //credit link
    func creditlink()
    {
        print(lcid)
        print(lcCredit)
        print(LC_course)
        print(LC_chapter)
        let params:[String:String] = ["lecture_id":lcid,"lecture_credit":lcCredit,"course_id":LC_course,"chapter_id":LC_chapter]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)deduct_credit_for_lectures/?token="
        Alamofire.request(kLurl+tokenstr+"&student_id="+student_id, method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    KGModal.sharedInstance().hide(animated: true)
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
                    mainview.course_id = self.LC_course
                    mainview.chapter_id = self.LC_chapter
                    mainview.Lecture_idstr = self.lcid
                    mainview.navclas = "List"
                    mainview.chaptername = self.chaptername
                    self.navigationController?.pushViewController(mainview, animated: true)
                    //self.present(mainview, animated:true, completion: nil)
                }
                else if res == "Your credit limit is exhausted. Please purchase a package to continue."
                {
                    self.sponser1 = Bundle.main.loadNibNamed("AlertPopUp", owner: self, options: nil)?[0] as! AlertPopUp
                    //            sponser.layer.zPosition = 2
                    self.sponser1.layer.cornerRadius = 5.0
                    self.sponser1.layer.masksToBounds = true
                    KGModal.sharedInstance().show(withContentView: self.sponser1, andAnimated: true)
                    KGModal.sharedInstance().tapOutsideToDismiss = false
                    //print(booklistarr.count)
                    self.sponser1.creditlab.text = res
                    //sponser1.okbtn.tag = indexPath.row + 123
                    self.sponser1.cancle.addTarget(self, action: #selector(LecturesDetailsViewController.cancel(sender:)), for: UIControlEvents.touchUpInside)
                    self.sponser1.okbtn.addTarget(self, action: #selector(LecturesDetailsViewController.ok(sender:)), for: UIControlEvents.touchUpInside)
                    
                }
                SVProgressHUD.dismiss()
                
            }
            //SVProgressHUD.dismiss()
        }
    }
    
    @objc func ok(sender:UIButton!)
    {
        sponser1.okbtn.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser1.okbtn.setTitleColor(UIColor.white, for: .normal)
        KGModal.sharedInstance().hide(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
        appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
        //            let navController = UINavigationController(rootViewController: mainview)
        currentview.pushViewController(mainview, animated: false)
    }
    
    @objc func cancel(sender:UIButton!)
    {
        sponser1.cancle.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser1.cancle.setTitleColor(UIColor.white, for: .normal)
        KGModal.sharedInstance().hide(animated: true)
    }

}
