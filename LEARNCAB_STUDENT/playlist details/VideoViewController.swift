//
//  VideoViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 07/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import KGModal
import DropDown
import SVProgressHUD
import BrightcovePlayerSDK
import BrightcovePlayerUI
import GoneVisible

var kViewControllerPlaybackServicePolicyKey = "BCpkADawqM2vBBhhvlngk1o5rU1EXNttB6Q7qzZ8RxbIey8ep-7JJjmyWpLP67R7EifVPr63WgN9qkdyDiOmF5oSLTaXbB5k6lO19VrHnm_7vVoRliKnqTOIJK98w9zMLbYl41duH8vQd51k"
var kViewControllerAccountID = "5797077890001"

class VideoViewController: UIViewController,UIWebViewDelegate , BCOVPlaybackControllerDelegate {

    var voideID : String!
    
 let sharedSDKManager = BCOVPlayerSDKManager.shared()
    let playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)
    var playbackController :BCOVPlaybackController
    var preferredPeakBitRate: Double!
    @IBOutlet weak var videoContainerView: UIView!
   
    var sponser : QualityPopup!
    var currentstr : String!
    var url : URL?
    var videostr : String!
    var content : String!
    var viewstr : String!
    var index : Int!
    var indexpath : Int!
    var bloodgrparr : NSMutableArray!
    @IBOutlet weak var buttomview : UIView!
    @IBOutlet weak var NXview : UIView!
    @IBOutlet weak var Prevview : UIView!
    @IBOutlet weak var Npview : UIView!
    @IBOutlet weak var webview : UIWebView!
    var playlist = [Dictionary<String,AnyObject>]()
    var name : String!
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
    
    var landscapeOnly = false
    
    var controllername : String!
    required init?(coder aDecoder: NSCoder) {
        playbackController = (sharedSDKManager?.createPlaybackController())!
        super.init(coder: aDecoder)
        playbackController.delegate = self
        playbackController.isAutoAdvance = true
        playbackController.isAutoPlay = true
        playbackController.setAllowsExternalPlayback(true)
    }
    
    @IBOutlet var detailswebviewheight : NSLayoutConstraint!
    var curentTime : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewstr)
        
        let i = navigationController?.viewControllers.index(of: self)
        UserDefaults.standard.set(i, forKey:"nav")
        UserDefaults.standard.synchronize()
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        var colors = [UIColor]()
        colors.append(UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1))
        colors.append(UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)

        self.navigationController?.navigationBar.isHidden = false
        
        var options = BCOVPUIPlayerViewOptions()
        options.presentingViewController = self
        var controlsView = BCOVPUIBasicControlView.withVODLayout()
        
        // Set up our player view. Create with a standard VOD layout.
        var playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: controlsView)
        
        // full Screen button event function
        var screenModeButton = playerView?.viewWithTag((BCOVPUIViewTag.buttonScreenMode).rawValue) as? UIControl
        screenModeButton?.removeTarget(nil, action: nil, for: .allTouchEvents)
        landscapeOnly = false
        screenModeButton?.addTarget(self, action: #selector(self.handleScreenModeButton(_:)), for: .touchUpInside)
        
        // Install in the container view and match its size.
        playerView?.frame = self.videoContainerView.bounds
        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainerView.addSubview(playerView!)
        
        requestContentFromPlaybackService()
    
        self.Prevview.isHidden = true
        self.NXview.isHidden = true
        self.Npview.isHidden = true
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "VIDEO"
        self.navigationController?.navigationBar.isHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(playlist)
        print(kViewControllerVideoID)
         playbackController.play()
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
    
    @objc func handleScreenModeButton(_ sender: Any) {
        if landscapeOnly == true {
            landscapeOnly = false
            playbackController.play()
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
            self.Prevview.visible()
            self.NXview.visible()
            self.Npview.visible()
            self.buttomview.visible()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myOrientation = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIApplication.shared.setStatusBarHidden(false, with: .none)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else{
            landscapeOnly = true
            
            self.Prevview.isHidden = true
            self.NXview.isHidden = true
            self.Npview.isHidden = true
            self.Prevview.gone()
            self.NXview.gone()
            self.Npview.gone()
           self.buttomview.gone()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.myOrientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIApplication.shared.setStatusBarHidden(true, with: .none)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
    }
    
    func requestContentFromPlaybackService() {
        playbackService?.findVideo(withVideoID: "ref:"+kViewControllerVideoID, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                print("video name: \(v.properties["name"] as AnyObject)")
                print("video id: \(v.properties["id"] as AnyObject)")
                print("video thumbnail: \(v.properties["thumbnail"] as AnyObject)")
                print("video metadata: \(v.properties)")
                self.playbackController.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController?, playbackSession session: BCOVPlaybackSession?, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent?) {
        if (lifecycleEvent?.eventType == kBCOVPlaybackSessionLifecycleEventPlay) {
            print("ViewController Debug - Received lifecycle play event.")
        } else if (lifecycleEvent?.eventType == kBCOVPlaybackSessionLifecycleEventPause) {
            print("ViewController Debug - Received lifecycle pause event.")
        }
    }
    
    
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        print("Progress: \(progress) seconds")
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView?, willTransitionTo screenMode: BCOVPUIScreenMode) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView?, didTransitionTo screenMode: BCOVPUIScreenMode) {
        UIView.setAnimationsEnabled(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    @IBAction func backbutton(_sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func next(_ sender: UIButton)
    {
        indexpath = indexpath+1
        print(indexpath)
        playbackController.allowsBackgroundAudioPlayback = false
        playbackController.pause()
        let  urlstr = self.arrlist[indexpath] as! String
        let url1 : String = urlstr
        let url: URL? = NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        let imageExtensions = ["png", "jpg", "gif"]
        let videoExtentions = ["mp4","mov"]
        let notesExtentions = ["svg","pdf","doc","zip"]
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
         playbackController.allowsBackgroundAudioPlayback = false
         playbackController.pause()
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
        indexpath = indexpath+1
        print(indexpath)
         playbackController.allowsBackgroundAudioPlayback = false
         playbackController.pause()
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
         playbackController.allowsBackgroundAudioPlayback = false
          playbackController.pause()
      
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

    @objc func okbutton(sender:UIButton!)
    {
        let dropDown = DropDown()
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
    }
}

