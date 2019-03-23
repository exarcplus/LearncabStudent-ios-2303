//
//  TutorialViewController.swift
//  hello
//
//  Created by Exarcplus on 2/13/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipBtn: UIButton!
  
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            //tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.isHidden = true
        pageControl.addTarget(self, action: Selector(("didChangePageControlValue")), for: .valueChanged)
        let clr  = UIColor(red: 18/255, green: 98/255, blue: 151/255, alpha: 1)
        UIApplication.shared.statusBarView?.backgroundColor = clr
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destination is TutorialPageViewController {
           // tutorialPageViewController.tutorialDelegate = self
        }
    }
    
    @IBAction func skipBtnpressed(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)
        
    }
    
    func didChangePageControlValue() {
       // tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

/**extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
**/
