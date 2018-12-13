        //
//  HomePageViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 11/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import KGModal
//import DKChainableAnimationKit
import Alamofire
import SVProgressHUD
import ActionSheetPicker_3_0
import SDWebImage
import ZRScrollableTabBar
import LGSideMenuController
import GoneVisible

class HomePageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZRScrollableTabBarDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var searchimg: UIImageView!
    var searchstr: String!
    @IBOutlet weak var popbtn : UIButton!
    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var midview : UIView!
    @IBOutlet weak var dropimg : UIImageView!
    @IBOutlet weak var chapCollectionView : UICollectionView!
    @IBOutlet weak var collectionview : UICollectionView!
    var datasarr = [Dictionary<String,AnyObject>]()
    var detailarr = [Dictionary<String,AnyObject>]()
    var listarr = [Dictionary<String,AnyObject>]()
    var topstr : String!
    var dataarr = [String]()
    var idarr = [String]()
    var tokenstr : String!
    var student_id : String!
    var courseName : String!
    var course_id : String!
    var papername : String!
    //var search: Search<Entity>!
    var cellwidth : CGFloat!
    var searcharr = [Dictionary<String,AnyObject>]()
    var imageUrlArray:[String] = [String]()
    var imageCount:[String] = [String]()
    var name:[String] = [String]()
    var eimage:String = ""
    var ename:String = ""
    var eid:String = ""
    var echapter:String = ""
    var edescription:String = ""
    var elevel:String = ""
    var epaper:String = ""
    var esection:String = ""
    var esno:String = ""
    var eunit:String = ""
    var edate:String = ""
//    var eother_region:String = ""
//    var eregion:String = ""
//    var euserid:String = ""
    
    struct Objects {
        var Eimage:String!
        var Eid:String!
        var Echapter:String!
        var Edescription:String!
        var Elevel:String!
        var Epaper:String!
        var Esection:String!
        var Esno:String!
        var Eunit:String!
        var Edate:String!
//        var Eother_region:String!
//        var Eregion:String!
//        var Euserid:String!
//        var Ename:String!
    }
    
    var objectArray = [Objects]()
    var objectArrayFilter = [Objects]()
    var inSearchMode = false
    
    var Tabbar:ZRScrollableTabBar!
    @IBOutlet weak var Tabbarview: UIView!
    var colorArray = [UIColor.red, UIColor.green, UIColor.blue]
    @IBOutlet weak var chapterlab : UITextField!
    @IBOutlet weak var courseLable : UILabel!
    @IBOutlet weak var couseListBtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topstr = "0"
        searchstr = "0"
        topview.gone()
        //topview.isHidden = true
        //searchbar.isHidden = true
        
        var colors = [UIColor]()
        colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
        colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
         self.navigationController?.navigationBar.isHidden = false
       // midview.animation.moveX(100.0).thenAfter(1.0).makeScale(2.0).animate(2.0)
        
        
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
        
//        var count = [5, 10, -6, 75, 20]
//        count.sort { (val1: Int, val2: Int) -> Bool in
//            print("val1: \(val1) - val2: \(val2)" )
//            return val1 < val2
//        }
//        var someInts:[Int] = [10, 20, 30]
//        
//        for index in someInts {
//            print( "Value of index is \(index)")
//        }
//        print(count)
//        println(ascending)
        
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
        Tabbar.selectItem(withTag: 1)
        Tabbar.frame = CGRect(x: 0, y: 0,width: UIScreen.main.bounds.size.width, height: Tabbarview.frame.size.height);
        Tabbarview.addSubview(Tabbar)

        if let flowLayout = chapCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
       
        self.intiallink()
       
        self.view.endEditing(true)
       // self.collectionview.reloadData()
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func scrollableTabBar(_ tabBar: ZRScrollableTabBar!, didSelectItemWithTag tag: Int32) {
        if tag == 2
        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesListViewController") as! LecturesListViewController
//            let nav = UINavigationController.init(rootViewController: mainview)
//            appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
//            appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
//            appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
//            appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
//            appDelegate.SideMenu.leftViewStatusBarStyle = .default
//            var rect = appDelegate.SideMenuView.view.frame;
//            rect.size.width = 240;
//            appDelegate.SideMenuView.view.frame = rect
//            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
//            print(appDelegate.SideMenu)
//            self.present(appDelegate.SideMenu, animated:true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesListViewController") as! LecturesListViewController
            currentview.pushViewController(mainview, animated: false)
        }
        else if tag == 3
        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//            let nav = UINavigationController.init(rootViewController: mainview)
//            appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
//            appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
//            appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
//            appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
//            appDelegate.SideMenu.leftViewStatusBarStyle = .default
//            var rect = appDelegate.SideMenuView.view.frame;
//            rect.size.width = 240;
//            appDelegate.SideMenuView.view.frame = rect
//            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
//            print(appDelegate.SideMenu)
//            self.present(appDelegate.SideMenu, animated:true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            currentview.pushViewController(mainview, animated: false)
        }
        else if tag == 4
        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
//            let nav = UINavigationController.init(rootViewController: mainview)
//            appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
//            appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
//            appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
//            appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
//            appDelegate.SideMenu.leftViewStatusBarStyle = .default
//            var rect = appDelegate.SideMenuView.view.frame;
//            rect.size.width = 240;
//            appDelegate.SideMenuView.view.frame = rect
//            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
//            print(appDelegate.SideMenu)
//            self.present(appDelegate.SideMenu, animated:true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
             appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PackageViewController") as! PackageViewController
            currentview.pushViewController(mainview, animated: false)
            
        }
        else if tag == 5
        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//            let nav = UINavigationController.init(rootViewController: mainview)
//            appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
//            appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
//            appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
//            appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
//            appDelegate.SideMenu.leftViewStatusBarStyle = .default
//            var rect = appDelegate.SideMenuView.view.frame;
//            rect.size.width = 240;
//            appDelegate.SideMenuView.view.frame = rect
//            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
//            print(appDelegate.SideMenu)
//            self.present(appDelegate.SideMenu, animated:true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentview = appDelegate.SideMenu.rootViewController as! UINavigationController
            appDelegate.SideMenu.hideLeftView(animated: true, completionHandler: nil)
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            currentview.pushViewController(mainview, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func opensidemenu (_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SideMenu.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func popbtnclick (_sender: UIButton)
    {
       
        if topstr == "0"
        {
            self.chapCollectionView.reloadData()
            topstr = "1"
            self.topview.visible()
        }
        else
        {
            self.topview.gone()
          
            topstr = "0"

        }
    }
    
 //course link
    func intiallink()
    {
        if UserDefaults.standard.string(forKey: "course_id") == nil
        {
            print(tokenstr)
//        print(passuserid)
            let params:[String:String] = ["token":tokenstr,"lc_student_id":student_id]
            SVProgressHUD.show()
             let kLurl = "\(kBaseURL)login_student_get_course"
            Alamofire.request(kLurl, method: .get, parameters: params).responseJSON { response in
            
                print(response)
            
                let result = response.result
                print(response)
            
                if let dict = result.value as? Dictionary<String,AnyObject>{
                
                    if let dat = dict["data"] as? [Dictionary<String,AnyObject>]  {
                        print(dat)
                        self.datasarr = dat
                        print(self.datasarr.count)
                        if self.datasarr.count != 0
                        {
                            let coursename = self.datasarr[0]["course_name"] as! String
                            self.courseLable.text = coursename
                            UserDefaults.standard.set(coursename, forKey:"course_name")
                            UserDefaults.standard.synchronize()
                            
                            
                            let courseid = self.datasarr[0]["course_id"] as! String
                            UserDefaults.standard.set(courseid, forKey:"course_id")
                            UserDefaults.standard.synchronize()
                            if self.datasarr.count > 1
                            {
                                self.dropimg.isHidden = false
                                self.couseListBtn.isUserInteractionEnabled = true
                            }
                            else
                            {
                                self.dropimg.isHidden = true
                                self.couseListBtn.isUserInteractionEnabled = false
                            }
                        
                            self.datalink()
                        }
                       
                        SVProgressHUD.dismiss()
                    }
                    else
                    {
                    //self.myclass.ShowsinglebutAlertwithTitle(title: self.myclass.StringfromKey(Key: "LearnCab"), withAlert:self.myclass.StringfromKey(Key: "checkinternet"), withIdentifier:"internet")
                        SVProgressHUD.dismiss()
                    }
                }
            SVProgressHUD.dismiss()
            }
        }
        else
        {
            let params:[String:String] = ["token":tokenstr,"lc_student_id":student_id]
            SVProgressHUD.show()
            let kLurl = "\(kBaseURL)login_student_get_course"
            Alamofire.request(kLurl, method: .get, parameters: params).responseJSON { response in
                
                print(response)
                
                let result = response.result
                print(response)
                
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    
                    if let dat = dict["data"] as? [Dictionary<String,AnyObject>]  {
                        print(dat)
                        self.datasarr = dat
                        print(self.datasarr.count)
                        if self.datasarr.count > 1
                        {
                            self.dropimg.isHidden = false
                            self.couseListBtn.isUserInteractionEnabled = true
                        }
                        else
                        {
                            self.dropimg.isHidden = true
                            self.couseListBtn.isUserInteractionEnabled = false
                        }
                    }
                }
            }
                self.course_id = UserDefaults.standard.string(forKey: "course_id")
                print(self.course_id)
                let name = UserDefaults.standard.string(forKey: "course_name")
                print(name)
                self.courseLable.text = (name as! String)
                self.datalink()
        }
        
    }
    
    @IBAction func searchbutton(_sender : UIButton!)
    {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        mainview.course_idstr = course_id
        self.present(mainview, animated:true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionview
        {
//            if inSearchMode{
//                print(objectArrayFilter.count)
//                return objectArrayFilter.count
//            }
//            print(objectArray.count)
            return listarr.count
        }
        else if collectionView == chapCollectionView
        {
            return self.datasarr.count
        }
        else
        {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == collectionview
        {
        if UIScreen.main.bounds.size.width == 320
        {
            cellwidth = 132
            let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
            flow.minimumInteritemSpacing = 1
            flow.minimumLineSpacing = 1
            return CGSize(width: 152, height: 200)

        }
        else
        {
            let numberOfCellInRow : Int = 2
            let padding : Int = 8
            let collectionCellWidth : CGFloat = (collectionView.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
            cellwidth = collectionCellWidth

            //            return CGSize(width: collectionCellWidth , height: collectionCellWidth)
            return CGSize(width: collectionCellWidth , height: 200)
        }
        }
        else
        {
            let cellsize = CGSize(width: (collectionview.bounds.size.width/2) - 12, height:50)
            
            return cellsize
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       if collectionView == chapCollectionView
       {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            let name = self.datasarr[indexPath.row]["course_name"] as! String
            var myStringArr = name.components(separatedBy: " ")
            let Firststr: String = myStringArr [0]
            print(Firststr)
            cell.courseName.text = Firststr
        
                print(self.colorArray)
        
//            let color = self.colorArray[indexPath.row]
//            cell.courseName.backgroundColor = color
        //let myColor: UIColor = .random
            cell.courseName.backgroundColor = UIColor.random
            cell.chpname.text = self.datasarr[indexPath.row]["course_name"] as! String
            return cell;
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.chpname.preferredMaxLayoutWidth = 50
            cell.chpname.text = self.listarr[indexPath.row]["chapter"] as! String
            
            let img = self.listarr[indexPath.row]["image"] as! String
            //let img = "https://static.pexels.com/photos/236636/pexels-photo-236636.jpeg"
            print(img)
            
            if img == ""
            {
                cell.imgview.image = UIImage.init(named: "dft_img.png")
            }
            else
            {
                let newString = img.replacingOccurrences(of: " ", with: "%20")
                //let newString = "https://www.learncab.com/learncab/all_images/chapters/dCSiChbTchinmay-coming-soon.png"
                print(newString)
                cell.imgview.sd_setImage(with: URL(string: newString))
             
                //cell.imgview.sd_setImage(with: URL(string: newString))
            }

            return cell;
        }
      
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//
//            let cellsize = CGSize(width: (chapCollectionView.bounds.size.width/2) - 12, height:90)
//
//            return cellsize
//
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == chapCollectionView
        {
            self.topview.gone()
            //self.topview.isHidden = true
            self.midview.isHidden = false
            let coursename = self.datasarr[indexPath.row]["course_name"] as! String
            self.courseLable.text = coursename
            UserDefaults.standard.set(coursename, forKey:"course_name")
            UserDefaults.standard.synchronize()
            
            let courseid = self.datasarr[indexPath.row]["course_id"] as! String
            UserDefaults.standard.set(courseid, forKey:"course_id")
            UserDefaults.standard.synchronize()
             self.datalink()
            //self.droupdownlink()
        }
        else if collectionView == collectionview
        {

                let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesDetailsViewController") as! LecturesDetailsViewController
            
                mainview.chapternamestr = self.listarr[indexPath.row]["chapter"] as! String
                mainview.descript = self.listarr[indexPath.row]["description"] as! String
                mainview.courid = course_id
                mainview.chapterid = self.listarr[indexPath.row]["_id"] as! String
                //self.present(mainview, animated:true, completion: nil)
               self.navigationController?.pushViewController(mainview, animated: true)
            
                self.topview.gone()
                self.midview.isHidden = false
//            }
        }
    }
    
   
    
    
    @IBAction func paper_clicked(_ sender: UIButton)
    {
       
        //self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "select the paper", rows: dataarr , initialSelection: 0,doneBlock: {
            picker, value, index in
            //self.pickercourse.placeholder = ""
            self.chapterlab.text = index as? String
            let paperstr = index as! String
            print(paperstr)
            let formattedString = paperstr.replacingOccurrences(of: " ", with: "%20")
            self.papername = formattedString
            print(self.papername)
            print("value = \(value)")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            self.listlink()
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
       
    }
    
    
    func droupdownlink()
    {
        self.course_id = UserDefaults.standard.string(forKey: "course_id")
        print(self.course_id)
        //let params:[String:String] = [ ]
        let params:[String:String] = ["token":tokenstr]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)student_chapters_filter/"
        Alamofire.request(kLurl+course_id+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.detailarr = list
                    print(self.detailarr)
                    self.dataarr.removeAll()
                    if self.detailarr.count != 0
                    {
                        
                        for c in 0 ..< self.detailarr.count
                        {
                            let course = self.detailarr[c]["paper"] as! String
                            self.dataarr.append(course)
//                            let idstr = self.detailarr[c]["course_id"] as! String
//                            self.idarr.append(idstr)
//                            print(self.idarr)
                        }
                    }
                    
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    func listlink()
    {
        self.course_id = UserDefaults.standard.string(forKey: "course_id")
        print(self.course_id)
        //let params:[String:String] = [ ]
        let params:[String:String] = ["token":tokenstr]
        SVProgressHUD.show()
         let kLurl = "\(kBaseURL)student_chapters_with_paper/"
        Alamofire.request(kLurl+course_id+"/"+papername+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)

                        self.collectionview.reloadData()
                        self.droupdownlink()
                   
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    
    func datalink()
    {
        self.course_id = UserDefaults.standard.string(forKey: "course_id")
        print(self.course_id)
        let params:[String:String] = ["token":tokenstr]
        SVProgressHUD.show()
         let kLurl = "\(kBaseURL)student_chapters/"
        Alamofire.request(kLurl+course_id+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)

                        self.collectionview.reloadData()
                        self.droupdownlink()
                    
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""
        {
            
            inSearchMode = false
            
            view.endEditing(true)
            
           self.collectionview.reloadData()
            
        }
        else
        {
            
            inSearchMode = true
            
            
            objectArrayFilter = objectArray.filter { $0.Epaper.localizedCaseInsensitiveContains(searchBar.text!) || $0.Echapter.localizedCaseInsensitiveContains(searchBar.text!) || $0.Eunit.localizedCaseInsensitiveContains(searchBar.text!) || $0.Elevel.localizedCaseInsensitiveContains(searchBar.text!)}
            //            objectArrayFilter = objectArray.filter { $1.Echapter.localizedCaseInsensitiveContains(searchBar.text!) }
            //            objectArrayFilter = objectArray.filter { $2.Emobile_no.localizedCaseInsensitiveContains(searchBar.text!) }
            print(objectArrayFilter)
            
            self.collectionview.reloadData()
            
            
        }
    }
   
    
    @IBAction func logoutbutton(_sender : UIButton)
    {
        
        let uiAlert = UIAlertController(title: "LOGOUT", message: "Do you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            print("Click of default button")
            
            UserDefaults.standard.removeObject(forKey: "Logindetail")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.synchronize()
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav = UINavigationController.init(rootViewController: mainview)
            self.present(nav, animated:true, completion: nil)
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        
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

