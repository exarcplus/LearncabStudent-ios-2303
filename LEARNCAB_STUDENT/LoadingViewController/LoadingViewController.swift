//
//  LoadingViewController.swift
//  hello
//
//  Created by Exarcplus on 2/13/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import LGSideMenuController
import SystemConfiguration

class LoadingViewController: UIViewController {
 

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            self.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        },completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
  
        })
        if self.isInternetAvailable()
        {
            let dispatchTime3: DispatchTime = DispatchTime.now() + Double(Int64(3.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime3, execute: {
                 self.Loadview()
            })
           
        }else{
             self.view.makeToast("No Internet Connection", duration: 3.0, position: .bottom)
            let dispatchTime3: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime3, execute: {
                 exit (0);
            })
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Loadview()
    {
        
        if UserDefaults.standard.value(forKey: "Logindetail") == nil
        {
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            let nav = UINavigationController.init(rootViewController: mainview)
            self.present(nav, animated:true, completion: nil)
            
        }
        else
        {
//            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
//            let nav = UINavigationController.init(rootViewController: mainview)
//            self.present(nav, animated:true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            let nav = UINavigationController.init(rootViewController: mainview)
            appDelegate.SideMenu = LGSideMenuController.init(rootViewController: nav)
            appDelegate.SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
            appDelegate.SideMenuView = kmainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            appDelegate.SideMenu.leftViewStatusBarVisibleOptions = .onAll
            appDelegate.SideMenu.leftViewStatusBarStyle = .lightContent
            var rect = appDelegate.SideMenuView.view.frame;
            rect.size.width = 240;
            appDelegate.SideMenuView.view.frame = rect
            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
            print(appDelegate.SideMenu)
            self.present(appDelegate.SideMenu, animated:true, completion: nil)
        }
        
    }

    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        //   print(isReachable && !needsConnection)
        return (isReachable && !needsConnection)
    }

}
