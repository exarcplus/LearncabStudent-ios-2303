//
//  LecturesDetailsViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 20/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SDWebImage
import KGModal
import LGSideMenuController

class LecturesDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate{

    @IBOutlet weak var chapCollectionView : UICollectionView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var firsttableview : UITableView!
    @IBOutlet weak var secondtableview : UITableView!
    @IBOutlet weak var webView : UIWebView!
    @IBOutlet weak var firstView : UIView!
    @IBOutlet weak var secondView : UIView!
    @IBOutlet weak var secondemptylab : UILabel!
    @IBOutlet weak var firstemptyView : UIView!
    
    @IBOutlet weak var coursename : UILabel!
    @IBOutlet weak var papername : UILabel!
    
    var contentHeights : [CGFloat] = [0.0, 0.0]

    @IBOutlet weak var sendbtn : UIButton!
    @IBOutlet weak var textview : UITextView!
    @IBOutlet weak var senderimg : UIImageView!
    @IBOutlet var tableviewheight : NSLayoutConstraint!
     @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
     @IBOutlet var detailswebviewheight : NSLayoutConstraint!
    
    @IBOutlet weak var balancelab : UILabel!
    var sponser : CreditPopup!
    var sponser1 : AlertPopUp!

    var imgarr = NSMutableArray()
    var collectionindex : Int!
    var courid : String!
    var chapterid : String!
    var descript : String!
    var tokenstr : String!
    var student_id : String!
    var indexstr : String!
    var enddate : String!
    var chapternamestr : String!
    var questionstr : String!
    var senderimgstr :String!
    var lcid : String!
    var lcCredit : String!
    var LC_course : String!
    var LC_chapter : String!
    var lcstring : String!
    
    var lecturelistarr = [Dictionary<String,AnyObject>]()
    var lecturearr = [Dictionary<String,AnyObject>]()
    var listarr = [Dictionary<String,AnyObject>]()
    var qalistarr = [Dictionary<String,AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(lecturearr)
        print(courid)
        collectionindex = 0
        indexstr = "0"
        contentHeights = [0.0,0.0]
         self.navigationController?.navigationBar.isHidden = true
        firstView.isHidden = true
        secondView.isHidden = true
        firstemptyView.isHidden = true
        secondemptylab.isHidden = true
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            student_id = newResult["_id"] as! String
            print(student_id)
        }
        self.imgarr = [UIImage(named: "lc_sel.png")!, UIImage(named: "ic_lectures_inactive.png")!, UIImage(named: "ic_qan_inactive.png")!]
        
        print(descript)
       
        
        self.papername.text =  self.chapternamestr

        let name = UserDefaults.standard.string(forKey: "course_name")
        print(name)
        self.coursename.text = (name as! String)
        
        let borderColor = UIColor.darkGray.cgColor
        textview.delegate = self
        //textview.text = "Ask your Instructor"
        textview.layer.borderColor =  borderColor.copy(alpha: 0.1)
        textview.layer.borderWidth = 1.0;
        textview.layer.cornerRadius = 20;
        
        let i = navigationController?.viewControllers.index(of: self)
        UserDefaults.standard.set(i, forKey:"nav")
        UserDefaults.standard.synchronize()
        
        secondtableview.estimatedRowHeight = 200
        secondtableview.rowHeight = UITableViewAutomaticDimension
        
        self.lecturelistlink()
       
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.totalcreditlink), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if lcstring == "" || lcstring == nil{
            
        }
        else
        {
            indexstr = "1"
            collectionindex = 1
            //self.chapCollectionView.scrollToItem(at: collectionindex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            self.chapCollectionView.reloadData()
            self.firstView.isHidden = false
            self.secondView.isHidden = true
            self.lecturelink()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.detailswebviewheight.constant = webView.scrollView.contentSize.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textview.textColor == UIColor.lightGray {
            textview.text = ""
            textview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textview.text == "" {
            
            textview.text = "Ask your Instructor"
            textview.textColor = UIColor.lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imgarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LecturesDetailsCollectionViewCell", for: indexPath) as! LecturesDetailsCollectionViewCell
         cell.img.image = imgarr.object(at: indexPath.row) as? UIImage
       
        if indexPath.item == collectionindex
        {
            cell.underLine.isHidden = false
            if indexstr == "0"
            {
                 cell.img.image = UIImage.init(named: "ic_my_course_info_active.png")
            }
            else if indexstr == "1"
            {
                cell.img.image = UIImage.init(named: "ic_lectures_active.png")
            }
            else if indexstr == "2"
            {
                cell.img.image = UIImage.init(named: "ic_qan_active.png.png")
            }
        }
        else
        {
            cell.underLine.isHidden = true
        }
        return cell;
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            indexstr = "0"
            collectionindex = indexPath.item
            self.chapCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            self.chapCollectionView.reloadData()
            self.firstView.isHidden = true
            self.secondView.isHidden = true
            self.lecturelistlink()
        }
        else if indexPath.row == 1
        {
            indexstr = "1"
            collectionindex = indexPath.item
            self.chapCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            self.chapCollectionView.reloadData()
            self.firstView.isHidden = false
            self.secondView.isHidden = true
            self.lecturelink()
        }
        else if indexPath.row == 2
        {
            indexstr = "2"
            collectionindex = indexPath.item
            self.chapCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            self.chapCollectionView.reloadData()
            self.firstView.isHidden = true
            self.secondView.isHidden = false
            self.questionlink()
        }
    }
    
    
    //back button
    @IBAction func backclick(_sender: UIButton!)
    {
        //self.navigationController?.popViewController(animated: true)
      self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == firsttableview
        {
             return lecturelistarr.count
        }
        else if tableView == secondtableview
        {
            return qalistarr.count
        }
        else
        {
            return listarr.count
        }
       
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension;
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == firsttableview
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesDetailsTableViewCell", for: indexPath) as! LecturesDetailsTableViewCell
            cell.selectionStyle = .none
            // self.heightLayoutConstraint.constant = self.firsttableview.contentSize.height
            cell.Lcname.text = self.lecturelistarr[indexPath.row]["faculty_name"] as! String
            cell.fcname.text = self.lecturelistarr[indexPath.row]["profession"] as! String
            let img = self.lecturelistarr[indexPath.row]["image"] as! String
            if img == "" || img == nil
            {
                cell.Lcimg.image = UIImage.init(named: "profile_unselect.png")
            }
            else
            {
                cell.Lcimg.sd_setImage(with: URL(string: img))
            }
            return cell;
        }
        else if tableView == secondtableview
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QandATableViewCell", for: indexPath) as! QandATableViewCell
            cell.selectionStyle = .none
           
            cell.nameLabel.text = self.qalistarr[indexPath.row]["student_name"] as! String
            let qus =  self.qalistarr[indexPath.row]["question"] as! String
            cell.questionLable.text = "Q:  \(qus)\n"
            
           var str = self.qalistarr[indexPath.row]["answer"] as! String
            let str1 = str.replacingOccurrences(of: "<[^>]+>;", with: "", options: .regularExpression, range: nil)
            print(str1)
            let pr = str1.withoutHtmlTags
            print(pr)
            cell.webView1.text = "A:  \(pr)\n"
//            cell.webView1.delegate = self
//            cell.webView1.scrollView.isScrollEnabled = false
//            let font = UIFont.init(name: "Poppins-Light", size: 12)
//            cell.webView1.loadHTMLString("<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); \">\(str)</span>", baseURL: nil)
//            cell.detailsheight.constant = cell.webView1.scrollView.contentSize.height
//
            let enddt = self.qalistarr[indexPath.row]["created"] as! String
           
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date: Date? = dateFormatter.date(from: enddt)!
                dateFormatter.dateFormat = "d MMM yyyy"
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date!)
                print("EXACT_DATE : \(dateString)")
                cell.timeLabel.text = dateString
            let adstatus = self.qalistarr[indexPath.row]["admin_status"] as! String
            if adstatus == "0"
            {
                cell.statusLabel.text = "Pending"
                cell.statusLabel.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1)
            }
            else if adstatus == "1"
            {
                 cell.statusLabel.text = ""
                 cell.statusLabel.backgroundColor = UIColor.white
            }
            else
            {
                cell.statusLabel.text = "Rejected"
                cell.statusLabel.backgroundColor = UIColor.red
               
            }
              //  cell.timeLabel.text = dateString
           
            let img = self.qalistarr[indexPath.row]["student_image"] as! String
            if img == ""
            {
                cell.profileimg.image = UIImage.init(named: "profile_unselect.png")
            }
            else
            {
                cell.profileimg.sd_setImage(with: URL(string: img))
            }
            return cell;
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesDetailsTableViewCell", for: indexPath) as! LecturesDetailsTableViewCell
            cell.selectionStyle = .none
            cell.Lcname.text = self.listarr[indexPath.row]["lecture_title"] as! String
           
            let enddt = self.listarr[indexPath.row]["expires_in"] as! String
            if enddt == ""
            {
               cell.lctime.text = ""
            }
            else
            {
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date: Date? = dateFormatter.date(from: enddt)!
                dateFormatter.dateFormat = "d MMM yyyy h:mm a"
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date!)
                print("EXACT_DATE : \(dateString)")
                cell.lctime.text = "Expires on : \(dateString)"
            }
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == firsttableview
        {
            
        }
        else if tableView == secondtableview
        {
            
        }
        else
        {
            let datetime = Date()
            let dateFormatt = DateFormatter()
            dateFormatt.dateFormat = "yyyy-MM-dd HH:mm"
            let currentdate = dateFormatt.string(from: datetime)
            print(currentdate)
            
            
            let enddt = self.listarr[indexPath.row]["expires_in"] as! String
            print(enddt)
            if enddt == ""
            {
                sponser = Bundle.main.loadNibNamed("CreditPopup", owner: self, options: nil)?[0] as! CreditPopup
                //            sponser.layer.zPosition = 2
                sponser.layer.cornerRadius = 5.0
                sponser.layer.masksToBounds = true
                KGModal.sharedInstance().show(withContentView: sponser, andAnimated: true)
                KGModal.sharedInstance().tapOutsideToDismiss = true
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
                if currentdate < dateString
                {
                    let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
                    mainview.course_id = self.listarr[indexPath.row]["course_id"] as! String
                    mainview.chapter_id = self.listarr[indexPath.row]["chapter_id"] as! String
                    mainview.Lecture_idstr = self.listarr[indexPath.row]["lecture_id"] as! String
                    mainview.navclas = "Detail"
                    mainview.descptstr = self.descript
                    mainview.chaptername = self.chapternamestr
                    //self.navigationController?.pushViewController(mainview, animated: true)
                    self.navigationController?.pushViewController(mainview, animated: true)
                   // self.present(mainview, animated:true, completion: nil)
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
    }
    
    
    @objc func okbutton(sender:UIButton!)
    {
        sponser.okbtn.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser.okbtn.setTitleColor(UIColor.white, for: .normal)
       // KGModal.sharedInstance().hide(animated: true)
        print(listarr)
        self.lcid = self.listarr[sender.tag-123]["lecture_id"] as! String
        self.lcCredit = self.listarr[sender.tag-123]["lecture_credit"] as! String
        self.LC_course = self.listarr[sender.tag-123]["course_id"] as! String
        self.LC_chapter = self.listarr[sender.tag-123]["chapter_id"] as! String
        self.creditlink()
       
    }
    @objc func closebutton(sender:UIButton!)
    {
        sponser.cancle.backgroundColor = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        sponser.cancle.setTitleColor(UIColor.white, for: .normal)
        KGModal.sharedInstance().hide(animated: true)
    }
    
    
   
    
//
  //second tab
    func lecturelink()
    {
        print(courid)
        print(chapterid)
        let params:[String:String] = ["token":tokenstr,"student_id":student_id]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)lectuers_faculty/"
        Alamofire.request(kLurl+courid+"/"+chapterid+"/", method: .get, parameters: params).responseJSON { response in

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
                        self.firstemptyView.isHidden = false
                    }
                    else if self.listarr.count != 0
                    {
                        self.firstemptyView.isHidden = true
                        self.tableView.reloadData()
                    }
                }
            }
            SVProgressHUD.dismiss()

        }
       // SVProgressHUD.dismiss()
    }
    
//lecturelist first tab
    func lecturelistlink()
    {
        print(courid)
        print(chapterid)
        let params:[String:String] = ["token":tokenstr,"student_id":student_id]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)lectuers_faculty1/"
        Alamofire.request(kLurl+courid+"/"+chapterid+"/", method: .get, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.lecturelistarr = list
                    print(self.lecturelistarr)
                    if self.lecturelistarr.count != 0
                    {
                         self.senderimgstr = self.lecturelistarr[0]["image"] as! String
                        print(self.senderimgstr)
                        if self.descript == nil
                        {
                            
                        }
                        else
                        {
                            self.webView.delegate = self
                            self.webView.scrollView.isScrollEnabled = false
                            let des = self.descript
                            self.webView.loadHTMLString(des!, baseURL: nil)
                        }
                        
                        self.firsttableview.reloadData()
                    }
                }
            }
            SVProgressHUD.dismiss()
            
        }
        //SVProgressHUD.dismiss()
    }

    
    //Q And A fetching link
    func questionlink()
    {
        print(tokenstr)
        print(courid)
        print(chapterid)
        let params:[String:String] = ["course_id":courid,"chapter_id":chapterid]
        SVProgressHUD.show()
         let kLurl = "\(kBaseURL)fetch_all_q_and_a/?student_id="+student_id+"&token="
        Alamofire.request(kLurl+tokenstr, method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.qalistarr = list
                    print(self.qalistarr)
                    if self.qalistarr.count != 0
                    {
                        self.secondemptylab.isHidden = true
                        print(self.senderimgstr)
                        if self.senderimgstr == "" || self.senderimgstr == nil
                        {
                            
                        }
                        else
                        {
                            self.senderimg.sd_setImage(with: URL(string: self.senderimgstr))
                        }
                        self.secondtableview.reloadData()
                        
                    }
                    else
                    {
                        self.secondemptylab.isHidden = false
                    }
                }
            }
            SVProgressHUD.dismiss()
            
        }
        //SVProgressHUD.dismiss()
    }
    
    
    //Question Send link
    func quessendlink()
    {
        print(tokenstr)
        print(courid)
        print(chapterid)
        print(student_id)
        let params:[String:String] = ["student_id":student_id,"course_id":courid,"chapter_id":chapterid,"question":questionstr]
        SVProgressHUD.show()
         let kLurl = "\(kBaseURL)store_question/?token="
        Alamofire.request(kLurl+tokenstr, method: .post, parameters: params).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
            let res = dat["result"] as! String
                if res == "success"
                {
                    SVProgressHUD.dismiss()
                    self.textview.text = ""
                    self.questionlink()
                    self.view.endEditing(true)
                    let myAlert = UIAlertController(title:"LearnCab", message: "Please Wait for Admin Approve", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }

            }
            SVProgressHUD.dismiss()
            
        }
        //SVProgressHUD.dismiss()
    }
    
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
                    mainview.navclas = "Detail"
                    mainview.descptstr = self.descript
                    mainview.chaptername = self.chapternamestr
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
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    @objc func totalcreditlink()
    {
        print(lcid)
        print(lcCredit)
        print(LC_course)
        print(LC_chapter)
       
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)balance_credits/"+courid+"/"+chapterid+"/0"+"/?token="
        Alamofire.request(kLurl+tokenstr+"&student_id="+student_id, method: .post, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    self.balancelab.text = String(dat["balance_credits"] as! Int)
                }
                SVProgressHUD.dismiss()
                
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func sendclick(_sender: UIButton!)
    {
        self.questionstr = textview.text!
        if self.questionstr == ""
        {
            let myAlert = UIAlertController(title:"LearnCab", message: "Please enter question", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        else{
             self.quessendlink()
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
extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
                "", options:.regularExpression, range: nil)
    }
}
