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
