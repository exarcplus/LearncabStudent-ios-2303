//
//  DashboardViewController.swift
//  LearnCab
//
//  Created by Exarcplus on 19/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import ScrollableGraphView
import Alamofire
import SVProgressHUD
import ZRScrollableTabBar
import LGSideMenuController
import WOWCardStackView

class DashboardViewController: UIViewController,ScrollableGraphViewDataSource,ZRScrollableTabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var graphview : ScrollableGraphView!
    @IBOutlet weak var collectionview : UICollectionView!
    @IBOutlet weak var credit : UILabel!
    @IBOutlet weak var balancelab : UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let collectionMargin = CGFloat(16)
    let itemSpacing = CGFloat(10)
    let itemHeight = CGFloat(322)
    
    var itemWidth = CGFloat(0)
    var currentItem = 0
    
    var linePlotData = [Double]()
    var datearr = [String]()
    var calarr = [String]()
    var grapharr = [Dictionary<String,AnyObject>]()
    var listarr = [Dictionary<String,AnyObject>]()
    var numberOfDataItems = 29
    var tokenstr : String!
    var student_id : String!
    var main_courseid : String!
    var cellwidth : CGFloat!
    var Tabbar:ZRScrollableTabBar!
    @IBOutlet weak var Tabbarview: UIView!
    @IBOutlet weak var cardStackView: CardStackView!
    @IBOutlet weak var coursename : UILabel!
    @IBOutlet weak var level : UILabel!
    @IBOutlet weak var datelab : UILabel!
    @IBOutlet weak var newview: UIView!
    var orderNo: Int = 0
    var myindex : Int!
    var referenceLines = ReferenceLines()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
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
        //self.cardStackView.register(nib: UINib(nibName: "MyCard", bundle: nil))
        
        
        graphview.dataSource = self
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor(red: 18/255, green: 206/255, blue: 255/255, alpha: 1)
        linePlot.fillGradientEndColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        //        referenceLines.absolutePositions = [10, 20, 25, 30]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(0.5)
        
        // Setup the graph
        graphview.backgroundFillColor = UIColor.white
        graphview.dataPointSpacing = 80
        
        graphview.shouldAnimateOnStartup = true
        graphview.shouldAdaptRange = true
        graphview.shouldRangeAlwaysStartAtZero = true
        
        graphview.rangeMax = 50
        
        // Add everything to the graph.
        graphview.addReferenceLines(referenceLines: referenceLines)
        graphview.addPlot(plot: linePlot)
        graphview.addPlot(plot: dotPlot)
        
        
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
        Tabbar.selectItem(withTag: 3)
        Tabbar.frame = CGRect(x: 0, y: 0,width: UIScreen.main.bounds.size.width, height: Tabbarview.frame.size.height);
        Tabbarview.addSubview(Tabbar)
        
        self.listlink()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        
        let stt = datearr[pointIndex] as! String
        let tr = Double(stt)
        return tr!
    }
    
    func label(atIndex pointIndex: Int) -> String {
        let str = calarr[pointIndex] as! String
        print(str)
        return str
    }
    
    func numberOfPoints() -> Int {
        return self.datearr.count
    }
    
    
    func listlink()
    {
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let Login = "\(kBaseURL)login_student_get_course/?token="
        Alamofire.request(Login+tokenstr+"&lc_student_id="+student_id, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                    self.listarr = list
                    print(self.listarr)
                    if self.listarr.count != 0
                    {
                        self.main_courseid = self.listarr[0]["main_course_id"] as! String
                        if self.main_courseid == ""
                        {
                            
                        }
                        else{
                            self.creditlink()
                        }
                        
                        self.collectionview.reloadData()
                        
                    }
                    
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    func nextCard(in ins: CardStackView) -> CardView? {
        var card = cardStackView.dequeueCardView() as! MyCard
        if orderNo < self.listarr.count-1
        {
            orderNo += 1
        }
        else
        {
            orderNo = 0
        }
        print(orderNo)
        card = createCard(order: orderNo)
        return card
    }
    func cardStackView(_ cardStackView: CardStackView, cardAt index: Int) -> CardView
    {
        return createCard(order: index)
    }
    
    func numOfCardInStackView(_ cardStackView: CardStackView) -> Int {
        return self.listarr.count
    }
    
    func cardStackView(_: CardStackView, didSelect card: CardView)
    {
    }
    
    func createCard(order: Int) -> MyCard
    {
        var card = cardStackView.dequeueCardView() as! MyCard
        card.coursename.text = self.listarr[order]["main_course_name"] as! String
        card.level.text = self.listarr[order]["course_name"] as! String
        let enddt = self.listarr[order]["expiry_date"] as! String
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date: Date? = dateFormatter.date(from: enddt)!
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        card.datelab.text = dateString
        card.backgroundColor = UIColor.red
//        card.borderWidth = 1.0
//        card.borderColor = UIColor.lightGray
//        card.isShadowed = true
        myindex = order
        return card
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return listarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIScreen.main.bounds.size.width == 320
        {
            cellwidth = 318
            let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
            flow.minimumInteritemSpacing = 1
            flow.minimumLineSpacing = 1
            return CGSize(width: 318, height: 141)
            itemWidth = cellwidth
        }
        else
        {
            let numberOfCellInRow : Int = 1
            let padding : Int = 5
            let collectionCellWidth : CGFloat = (collectionView.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
            cellwidth = collectionCellWidth
            itemWidth = cellwidth
            //            return CGSize(width: collectionCellWidth , height: collectionCellWidth)
            return CGSize(width: collectionCellWidth , height: 141)
        }
        
    }
    
    //    func scrollToItemAtIndexPath(indexPath: NSIndexPath,atScrollPosition scrollPosition: UICollectionViewScrollPosition,animated: Bool)
    //    {
    //        self.creditlink()
    //    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        cell.coursename.text = self.listarr[indexPath.row]["main_course_name"] as! String
        cell.level.text = self.listarr[indexPath.row]["course_name"] as! String
        let enddt = self.listarr[indexPath.row]["expiry_date"] as! String
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date: Date? = dateFormatter.date(from: enddt)!
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        cell.datelab.text = dateString
        
        return cell;
        
        
    }
    // MARK: - UIScrollViewDelegate protocol
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellwidth)
        print(pageWidth)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionview!.contentSize.width)
        var newPage = Float(self.pageControl.currentPage)
        print(newPage)
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        print(newPage)
        let order = Int(newPage)
        self.main_courseid = self.listarr[order]["main_course_id"] as! String
        
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        self.creditlink()
    }
    
    
    
    func creditlink()
    {
        print(main_courseid)
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let Login = "\(kBaseURL)balance_and_used_credits/\(main_courseid+"/?token=")"
        Alamofire.request(Login+tokenstr+"&student_id="+student_id, method: .post, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    let blance = dat["balance_credits"] as! Int
                    self.balancelab.text = String(blance)
                    self.credit.text = dat["credits_per_month"] as! String
                    self.graphlink()
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    func graphlink()
    {
        print(main_courseid)
        let params:[String:String] = [:]
        SVProgressHUD.show()
        let Login = "\(kBaseURL)get_lectures_count_graph/\(main_courseid+"/?token=")"
        Alamofire.request(Login+tokenstr+"&lc_student_id="+student_id, method: .get, parameters: nil).responseJSON { response in
            
            print(response)
            
            let result = response.result
            print(response)
            if let dat = result.value as? Dictionary<String,AnyObject>{
                let res = dat["result"] as! String
                if res == "success"
                {
                    if let list = dat["data"] as? [Dictionary<String,AnyObject>]{
                        self.grapharr = list
                        if self.grapharr.count != 0
                        {
                            for c in 0 ..< self.grapharr.count
                            {
                                let dt = String(self.grapharr[c]["y"] as! Int)
                                let stt = self.grapharr[c]["y"] as! Int
                                let tr = Double(stt)
                                self.linePlotData.append(tr)
                                self.referenceLines.absolutePositions =  self.linePlotData
                                self.datearr.append(dt)
                                let cal = self.grapharr[c]["label"] as! String
                                self.calarr.append(cal)
                            }
                            
                            self.graphview.reload()
                        }
                    }
                }
            }
            SVProgressHUD.dismiss()
            
        }
    }
    
    @IBAction func opensidemenu (_ sender: UIButton)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SideMenu.showLeftView(animated: true, completionHandler: nil)
    }
   
    
}
