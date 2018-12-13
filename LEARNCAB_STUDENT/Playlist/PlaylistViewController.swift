//
//  PlaylistViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 01/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import FZAccordionTableView
import BrightcovePlayerUI
import BrightcovePlayerSDK

var kViewControllerVideoID = ""
class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,FZAccordionTableViewDelegate {

     var listarr = [Dictionary<String,AnyObject>]()
    var playlistarr = [Dictionary<String,AnyObject>]()
    var videoarr = [Dictionary<String,AnyObject>]()
    var datalistarr = [String]()
    var idlistarr = [String]()
    var lecturelistarr = [Dictionary<String,AnyObject>]()
    @IBOutlet weak var coursename : UILabel!
    @IBOutlet weak var chapname : UILabel!
    @IBOutlet weak var Listtable: FZAccordionTableView!
    var course_id : String!
    var chapter_id : String!
    var Lecture_idstr : String!
    var tokenstr : String!
    var student_id : String!
    var chaptername : String!
    var descptstr : String!
    var navclas : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        if UserDefaults.standard.value(forKey: "Logindetail") != nil{
            
            let result = UserDefaults.standard.value(forKey: "Logindetail")
            let newResult = result as! Dictionary<String,AnyObject>
            print(newResult)
            student_id = newResult["_id"] as! String
            print(student_id)
        }
        print(lecturelistarr)
        let name = UserDefaults.standard.string(forKey: "course_name")
        print(name)
        self.coursename.text = (name as! String)
        chapname.text = chaptername
        
        let i = navigationController?.viewControllers.index(of: self)
        UserDefaults.standard.set(i, forKey:"nav")
        UserDefaults.standard.synchronize()
        
        Listtable.register(UINib(nibName: "Pheadingview_s", bundle: nil), forHeaderFooterViewReuseIdentifier:"Pheadingview_s")
        Listtable.register(UINib.init(nibName:"QATableViewCell", bundle: nil),forCellReuseIdentifier: "QATableViewCell")
        Listtable.allowMultipleSectionsOpen = false
        Listtable.estimatedRowHeight = 44;
        Listtable.rowHeight = UITableViewAutomaticDimension
        
        self.lecturelink()
        self.title = "Book details"
        
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func lecturelink()
    {
        print(course_id)
        print(chapter_id)
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let kLurl = "\(kBaseURL)get_playlist/\(course_id+"/"+chapter_id+"/"+Lecture_idstr)/?token="
        Alamofire.request(kLurl+tokenstr+"&student_id="+student_id, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)
                    for i in 0 ..< self.listarr.count
                    {
                         self.playlistarr = self.listarr[0]["playlist"] as! [Dictionary<String, AnyObject>]
                        self.videoarr = self.listarr[i]["playlist"] as! [Dictionary<String, AnyObject>]
                        for i in 0 ..< self.videoarr.count
                        {
                            let video = self.videoarr[i]["video"] as! String
                            self.datalistarr.append(video)
                            let idstr = self.videoarr[i]["playlist_feature_id"] as! String
                            self.idlistarr.append(idstr)
                        }
                        print(self.idlistarr)
                    }
                    print(self.videoarr)

                     print(self.videoarr.count)
                     self.Listtable.reloadData()
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    
    // MARK: - Tabelview Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return  self.listarr.count;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let view:Pheadingview = (tableView.dequeueReusableHeaderFooterView(withIdentifier: "Pheadingview_s") as? Pheadingview)!
        view.Title_name.text = self.listarr[section]["playlist_title"] as? String
        
//        self.playlistarr.removeAll()
//        self.playlistarr = self.listarr[section]["playlist"] as! [Dictionary<String, AnyObject>]
        
        //view.Title_arraow.isHidden = false;
        return view.frame.size.height;
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
       
        let view:Pheadingview = (tableView.dequeueReusableHeaderFooterView(withIdentifier: "Pheadingview_s") as? Pheadingview)!
        
        view.Title_name.text = self.listarr[section]["playlist_title"] as! String
        
        //view.Title_arraow.isHidden = false;
        
        return view
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.playlistarr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(self.playlistarr)
       var arrstr =  self.playlistarr[(indexPath as NSIndexPath).row]["feature_name"] as! String
        print(arrstr)
        let  urlstr = self.playlistarr[(indexPath as NSIndexPath).row]["video"] as! String
        print(urlstr)
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg","pdf","doc","zip"]
        //let pdfExtentions = ["pdf","doc","zip"]
        let htmlExtentions = ["html"]
        print(self.playlistarr)
        let simpleTableIdentifier  = NSString(format:"QATableViewCell")
        let cell:QATableViewCell?=tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier as String) as? QATableViewCell
        let fztable  = tableView as! FZAccordionTableView
        if fztable.isSectionOpen((indexPath as NSIndexPath).section)
        {
            if imageExtensions.contains(pathExtention!)
            {
                let img = "https://apps.learncab.com/assets/images/big/image.png"
                cell?.logoimg.sd_setImage(with: URL(string: img))
//                cell?.logoimg.image = UIImage.init(named: "profile_unselect.png")
            }
            else if videoExtentions.contains(pathExtention!)
            {
                let img = "https://apps.learncab.com/assets/images/big/video.png"
                cell?.logoimg.sd_setImage(with: URL(string: img))
//                cell?.logoimg.image = UIImage.init(named: "profile_unselect.png")
            }
            else if notesExtentions.contains(pathExtention!)
            {
                let img = "https://apps.learncab.com/assets/images/big/notes.png"
                cell?.logoimg.sd_setImage(with: URL(string: img))
                 //cell?.logoimg.image = UIImage.init(named: "profile_unselect.png")
            }
//            else if pdfExtentions.contains(pathExtention!)
//            {
//                let img = "https://apps.learncab.com/assets/images/big/video.png"
//                cell?.logoimg.sd_setImage(with: URL(string: img))
//                // cell?.logoimg.image = UIImage.init(named: "profile_unselect.png")
//            }
            else if htmlExtentions.contains(pathExtention!)
            {
                let img = "https://apps.learncab.com/assets/images/big/quest.png"
                cell?.logoimg.sd_setImage(with: URL(string: img))
                 //cell?.logoimg.image = UIImage.init(named: "profile_unselect.png")
            }
            else
            {
                let img = "https://apps.learncab.com/assets/images/big/video.png"
                 cell?.logoimg.sd_setImage(with: URL(string: img))
            }
            cell?.namelable.text = arrstr
        }
        else
        {
            
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
       
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  urlstr = self.playlistarr[indexPath.row]["video"] as! String
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg","pdf","doc","zip"]
        //let pdfExtentions = ["pdf","doc","zip"]
        let htmlExtentions = ["html"]
        print(self.datalistarr.count)
        if imageExtensions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistImgViewController") as! PlaylistImgViewController
                mainview.imgstr = self.playlistarr[indexPath.row]["video"] as! String
                mainview.titlestr = self.playlistarr[indexPath.row]["feature_name"] as! String
                mainview.playlist = self.videoarr
                mainview.arrlist = self.datalistarr
                mainview.lecturearr = self.lecturelistarr
                mainview.courseid = self.course_id
                mainview.chapterid = self.chapter_id
                mainview.Lectureid = self.Lecture_idstr
                mainview.chapname = self.chaptername
                mainview.desc = self.descptstr
                mainview.playlist_id = self.playlistarr[indexPath.row]["playlist_feature_id"] as! String
                mainview.id_array = self.idlistarr
                mainview.controllername = self.navclas
                mainview.index = indexPath.row
            self.navigationController?.pushViewController(mainview, animated: true)
        }
        else if videoExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
                mainview.videostr = self.playlistarr[indexPath.row]["video"] as! String
                mainview.desc = self.descptstr
                mainview.playlist = self.videoarr
                mainview.index = indexPath.row
                mainview.arrlist = self.datalistarr
                mainview.lecturearr = self.lecturelistarr
                mainview.courseid = self.course_id
                mainview.chapterid = self.chapter_id
                mainview.Lectureid = self.Lecture_idstr
                mainview.chapname = self.chaptername
                mainview.playlist_id = self.playlistarr[indexPath.row]["playlist_feature_id"] as! String
                mainview.id_array = self.idlistarr
                mainview.controllername = self.navclas
             self.navigationController?.pushViewController(mainview, animated: true)
        }
        else if notesExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
                mainview.notes = self.playlistarr[indexPath.row]["video"] as! String
                mainview.desc = self.descptstr
                mainview.index = indexPath.row
                mainview.playlist = self.videoarr
                mainview.arrlist = self.datalistarr
                mainview.lecturearr = self.lecturelistarr
                mainview.courseid = self.course_id
                mainview.chapterid = self.chapter_id
                mainview.Lectureid = self.Lecture_idstr
                mainview.chapname = self.chaptername
                mainview.id_array = self.idlistarr
                mainview.controllername = self.navclas
                mainview.playlist_id = self.playlistarr[indexPath.row]["playlist_feature_id"] as! String
            self.navigationController?.pushViewController(mainview, animated: true)
        }
//        else if pdfExtentions.contains(pathExtention!)
//        {
//
//        }
        else if htmlExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
                mainview.quizstr = self.playlistarr[indexPath.row]["video"] as! String
                mainview.index = indexPath.row
                mainview.playlist = self.videoarr
                mainview.desc = self.descptstr
                mainview.arrlist = self.datalistarr
                mainview.lecturearr = self.lecturelistarr
                mainview.courseid = self.course_id
                mainview.chapterid = self.chapter_id
                mainview.Lectureid = self.Lecture_idstr
                mainview.chapname = self.chaptername
                mainview.id_array = self.idlistarr
                mainview.controllername = self.navclas
                mainview.playlist_id = self.playlistarr[indexPath.row]["playlist_feature_id"] as! String
            self.navigationController?.pushViewController(mainview, animated: true)

        }
        else
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
                mainview.videostr = self.playlistarr[indexPath.row]["video"] as! String
                mainview.index = indexPath.row
                print(indexPath.row)
                mainview.desc = self.descptstr
                mainview.playlist = self.videoarr
                mainview.arrlist = self.datalistarr
                mainview.lecturearr = self.lecturelistarr
                mainview.courseid = self.course_id
                mainview.chapterid = self.chapter_id
                mainview.Lectureid = self.Lecture_idstr
                mainview.chapname = self.chaptername
                mainview.id_array = self.idlistarr
                mainview.controllername = self.navclas
                mainview.playlist_id = self.playlistarr[indexPath.row]["playlist_feature_id"] as! String
                kViewControllerVideoID = self.playlistarr[indexPath.row]["video"] as! String
                print(kViewControllerVideoID)
            self.navigationController?.pushViewController(mainview, animated: true)
        }
    }
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    {
       
        //Listtable.reloadData();
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    {
        self.playlistarr.removeAll()
        self.playlistarr = self.listarr[section]["playlist"] as! [Dictionary<String, AnyObject>]
        print(self.playlistarr)
        Listtable.reloadData();
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    {
        //self.playlistarr.removeAll()
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?)
    {
        Listtable.reloadData();
    }
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
  
    @IBAction func backclick(_sender: UIButton)
    {
        print(navclas)
        if navclas == "Detail"
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesDetailsViewController") as! LecturesDetailsViewController
            mainview.lecturearr = self.lecturelistarr
            mainview.courid = self.course_id
            mainview.chapterid = self.chapter_id
            mainview.descript = self.descptstr
            mainview.chapternamestr = self.chaptername
            mainview.lcstring = navclas
            self.navigationController?.pushViewController(mainview, animated: true)
//            let mainview = self.navigationController?.viewControllers[1] as! LecturesDetailsViewController
//         self.navigationController?.popToViewController(mainview, animated: true)
        }
        else
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesListViewController") as! LecturesListViewController
            self.navigationController?.pushViewController(mainview, animated: true)
        }
    }
   
  
  

}
