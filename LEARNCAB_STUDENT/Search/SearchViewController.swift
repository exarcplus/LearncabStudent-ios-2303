//
//  SearchViewController.swift
//  SWSearchViewForSwift
//
//  Created by 박성원 on 2016. 7. 16..
//  Copyright © 2016년 ParkSungWon. All rights reserved.
//

import UIKit
import Alamofire
import LGSideMenuController

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    var searchstr : String!
    var course_idstr : String!
    var tokenstr : String!
    
    
    var items: [String] = ["i", "like", "swift", "language"]
    var filteredItems: [String] = []
    let NOTI_NAME = "hideSearchContainerView"
    var isFiltered:Bool = false
    var listarr = [Dictionary<String,AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.isHidden = true
        
        tokenstr = UserDefaults.standard.string(forKey: "tokens")
        print(tokenstr)
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0 //you can provide any
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UINib (nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "searchBarCell")
        self.dismissButton.addTarget(self, action: #selector(SearchViewController.dismissView), for: .touchUpInside)
    }
    
    //MARK : custom methods
    
    @objc func dismissView() {
        let notificationName = Notification.Name(NOTI_NAME)
        self.searchBar.resignFirstResponder()
        NotificationCenter.default.post(name:notificationName, object: nil)
    }
    
    //MARK: search view delegate and methods
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.shadowView.isHidden = false
        self.searchBar.resignFirstResponder()
        let notificationName = Notification.Name(NOTI_NAME)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // called when text changes (including clear)

        if searchText.characters.count == 0 {
            self.isFiltered = false
              self.tableView.reloadData()
        } else { 
            self.shadowView.isHidden = true
            self.isFiltered = true
            self.filteredItems = []
            print(searchText)
            
            let newString = searchText.replacingOccurrences(of: " ", with: "%20")
            let params:[String:String] = [:]
             let kLurl = "\(kBaseURL)student_chapters_search/\(course_idstr+"/"+newString)/?token="
            Alamofire.request(kLurl+self.tokenstr, method: .get, parameters: nil).responseJSON { response in
                
                print(response)
                
                let result = response.result
                print(response)
                if let dat = result.value as? Dictionary<String,AnyObject>{
                    self.listarr.removeAll()
                    if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                        
                        self.listarr = list
                        self.filteredItems.removeAll()
                        for c in 0 ..< self.listarr.count
                        {
                            let chp = self.listarr[c]["chapter"] as! String
                            self.filteredItems.append(chp)
                        }
                        let dispatchTime3: DispatchTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime3, execute: {
                             self.tableView.reloadData()
                            
                        })
                    }
                }
            }
        }
    }
    
    //MARK: uitableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltered
        {
            return  self.listarr.count
        }
        else
        {
            return self.listarr.count
        }
    }
    func makeAttributedString(title: String) -> NSAttributedString {
        //let titleAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedStringKey.foregroundColor: UIColor.black]
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        //let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        //titleString.append(subtitleString)
        
        return titleString
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension;
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if self.isFiltered {
            var project = self.listarr[indexPath.row]["chapter"] as! String// 1 is Search Bar Cell
           //cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(project)\n"
            //cell.textLabel?.attributedText = makeAttributedString(title: "\(project)\n")
//            cell.textLabel?.sizeToFit()
            cell.textLabel?.minimumScaleFactor = 0.1
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
           
           // let size = cell.textLabel?.sizeThatFits((cell.textLabel?.frame.size)!)
           
            //let height = size.height
//            cell.textLabel?.font = UIFont.systemFontOfSize(10.0)
        } else {
           cell.textLabel?.text = "" // 1 is Search Bar Cell
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LecturesDetailsViewController") as! LecturesDetailsViewController
        mainview.chapternamestr = self.listarr[indexPath.row]["chapter"] as! String
        mainview.descript = self.listarr[indexPath.row]["description"] as! String
        mainview.courid = course_idstr
        mainview.chapterid = self.listarr[indexPath.row]["_id"] as! String
        self.present(mainview, animated:true, completion: nil)
    }
    
    @IBAction func closebtn(_sender : UIButton)
    {
        self.dismiss(animated: true)

    }
   
  
}
