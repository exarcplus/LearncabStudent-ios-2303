//
//  LoadingViewController.swift
//  hello
//
//  Created by Exarcplus on 2/13/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import LGSideMenuController

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
        let dispatchTime3: DispatchTime = DispatchTime.now() + Double(Int64(3.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime3, execute: {
          self.Loadview()
           
        })
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
            appDelegate.SideMenu.leftViewStatusBarStyle = .default
            var rect = appDelegate.SideMenuView.view.frame;
            rect.size.width = 240;
            appDelegate.SideMenuView.view.frame = rect
            appDelegate.SideMenu.leftView().addSubview(appDelegate.SideMenuView.view)
            print(appDelegate.SideMenu)
            self.present(appDelegate.SideMenu, animated:true, completion: nil)
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
