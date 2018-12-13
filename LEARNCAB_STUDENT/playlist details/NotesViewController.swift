//
//  NotesViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 08/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
import SVProgressHUD

class NotesViewController: UIViewController,UIWebViewDelegate {

    var discription : String!
    var notes : String!
    var titlestr : String!
    var index : Int!
    var indexpath : Int!
    var playlist = [Dictionary<String,AnyObject>]()
    var nextarr = [Dictionary<String,AnyObject>]()
     var arrlist = [String]()
    var id_array = [String]()
    var lecturearr = [Dictionary<String,AnyObject>]()
    var courseid : String!
    var chapterid : String!
    var Lectureid : String!
    var chapname : String!
    var urlstring : String!
    var desc : String!
    var playlist_id : String!
    var arrindex : Int!
    var newstring : String!
    
    var controllername : String!
    @IBOutlet weak var NXview : UIView!
    @IBOutlet weak var Prevview : UIView!
    @IBOutlet weak var Npview : UIView!
    
    
    var url : URL?
    @IBOutlet weak var webview : UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
        colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        //self.navigationItem.title = titlestr
        self.navigationItem.title = "NOTES"
        
        let i = navigationController?.viewControllers.index(of: self)
        UserDefaults.standard.set(i, forKey:"nav")
        UserDefaults.standard.synchronize()
         SVProgressHUD.show()
        print(notes)
         newstring = notes.replacingOccurrences(of: " ", with: "%20")
        print(newstring)
        let url1 : String = newstring
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        //let url = URL(string: notes)
        let pathExtention = url?.pathExtension
         let notesExtentions = ["svg"]
         let notesExtentions1 = ["pdf"]
         let notesExtentions2 = ["doc"]
         let notesExtentions3 = ["zip"]
        if notesExtentions.contains(pathExtention!)
        {
            let path = Bundle.main.url(forResource: newstring, withExtension: "svg")
            print(newstring)
            let fileURL:URL = URL(fileURLWithPath: newstring)
            let req = URLRequest(url: fileURL)
            self.webview.loadRequest(req)
        }
        else if notesExtentions1.contains(pathExtention!)
        {
            let path = Bundle.main.url(forResource: newstring, withExtension: "pdf")
            print(path)
            let fileURL:URL = URL(fileURLWithPath: newstring)
            let req = URLRequest(url: fileURL)
            self.webview.loadRequest(req)
        }
        else if notesExtentions2.contains(pathExtention!)
        {
            let path = Bundle.main.url(forResource: newstring, withExtension: "doc")
            print(path)
            let fileURL:URL = URL(fileURLWithPath: newstring)
            let req = URLRequest(url: fileURL)
            self.webview.loadRequest(req)
        }
        else
        {
            let path = Bundle.main.url(forResource: newstring, withExtension: "zip")
            print(path)
            let fileURL:URL = URL(fileURLWithPath: newstring)
            let req = URLRequest(url: fileURL)
            self.webview.loadRequest(req)
        }
        
        
        webview.delegate = self as! UIWebViewDelegate
        webview.scrollView.isScrollEnabled = true
        webview.contentMode = .scaleAspectFit
        webview.backgroundColor = .clear
        webview.scrollView.maximumZoomScale = 2
        webview.scrollView.minimumZoomScale = 1
        webview.scalesPageToFit = true
        
        self.Prevview.isHidden = true
        self.NXview.isHidden = true
        self.Npview.isHidden = true
        
        /// webview loading
        self.load(url: newstring)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(playlist)
        for i in 0 ..< id_array.count
        {
            let str = id_array[i] as! String
            print(str)
            print(playlist_id)
            if playlist_id == str{
                print(i)
                arrindex = i
                indexpath = i
            }
        }
        print(indexpath)
        print(arrlist.startIndex)
        print(arrlist.endIndex)
        arrindex = indexpath + 1
        if arrlist.startIndex == indexpath {
            self.Prevview.isHidden = true
            self.NXview.isHidden = false
            self.Npview.isHidden = true
        }
        else if arrlist.endIndex == arrindex
        {
            self.Prevview.isHidden = false
            self.NXview.isHidden = true
            self.Npview.isHidden = true
        }
        else
        {
            self.Prevview.isHidden = true
            self.NXview.isHidden = true
            self.Npview.isHidden = false
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        //SVProgressHUD.dismiss()
    }
    
    func load(url: String) {
        if let url = URL(string: newstring) {
             webview.stopLoading()
            webview.loadRequest(URLRequest(url: url))
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backbutton(_sender: UIButton)
    {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//        print(viewControllers)
//        for aViewController in viewControllers {
//            if aViewController is PlaylistViewController {
//                self.navigationController!.popToViewController(aViewController, animated: true)
//            }
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton)
    {
        // SVProgressHUD.show()
        indexpath = indexpath+1
        print(indexpath)
        let  urlstr = self.arrlist[indexpath] as! String
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg","pdf","doc","zip"]
//        let pdfExtentions = ["pdf","doc","zip"]
        let htmlExtentions = ["html"]
        if imageExtensions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistImgViewController") as! PlaylistImgViewController
            mainview.imgstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if videoExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if notesExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            mainview.notes = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
//        else if pdfExtentions.contains(pathExtention!)
//        {
//
//        }
        else if htmlExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            mainview.quizstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            kViewControllerVideoID = self.arrlist[indexpath] as! String
            self.navigationController?.pushViewController(mainview, animated: true)
        }
        
    }
    
    @IBAction func previous(_ sender: UIButton)
    {
        // SVProgressHUD.show()
        indexpath = indexpath-1
        print(indexpath)
        let  urlstr = self.arrlist[indexpath] as! String
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg"]
        let pdfExtentions = ["pdf","doc","zip"]
        let htmlExtentions = ["html"]
        if imageExtensions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistImgViewController") as! PlaylistImgViewController
            mainview.imgstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.id_array = self.id_array
            mainview.desc = self.desc
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if videoExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if notesExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            mainview.notes = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
//        else if pdfExtentions.contains(pathExtention!)
//        {
//
//        }
        else if htmlExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            mainview.quizstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            kViewControllerVideoID = self.arrlist[indexpath] as! String
            self.navigationController?.pushViewController(mainview, animated: true)
        }
        
    }
    
    @IBAction func next1(_ sender: UIButton)
    {
        // SVProgressHUD.show()
        indexpath = indexpath+1
        print(indexpath)
        let  urlstr = self.arrlist[indexpath] as! String
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg"]
        let pdfExtentions = ["pdf","doc","zip"]
        let htmlExtentions = ["html"]
        if imageExtensions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistImgViewController") as! PlaylistImgViewController
            mainview.imgstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.index = indexpath
            mainview.arrlist = self.arrlist
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if videoExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.arrlist = self.arrlist
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else if notesExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            mainview.notes = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.arrlist = self.arrlist
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
//        else if pdfExtentions.contains(pathExtention!)
//        {
//            
//        }
        else if htmlExtentions.contains(pathExtention!)
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            mainview.quizstr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.arrlist = self.arrlist
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            self.navigationController?.pushViewController(mainview, animated:true)
        }
        else
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            mainview.videostr = self.arrlist[indexpath] as! String
            mainview.playlist_id = self.id_array[indexpath] as! String
            mainview.playlist = self.playlist
            mainview.arrlist = self.arrlist
            mainview.index = indexpath
            mainview.lecturearr = self.lecturearr
            mainview.courseid = self.courseid
            mainview.chapterid = self.chapterid
            mainview.Lectureid = self.Lectureid
            mainview.chapname = self.chapname
            mainview.desc = self.desc
            mainview.id_array = self.id_array
            mainview.controllername = self.controllername
            kViewControllerVideoID = self.arrlist[indexpath] as! String
            self.navigationController?.pushViewController(mainview, animated: true)
        }
        
    }
    @IBAction func previous1(_ sender: UIButton)
    {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as! PlaylistViewController
        mainview.lecturelistarr = self.lecturearr
        mainview.course_id = self.courseid
        mainview.chapter_id = self.chapterid
        mainview.Lecture_idstr = self.Lectureid
        mainview.chaptername = self.chapname
        mainview.descptstr = self.desc
        mainview.navclas = self.controllername
        self.navigationController?.pushViewController(mainview, animated:true)
    }


}
