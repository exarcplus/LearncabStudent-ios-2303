//
//  GetStartViewController.swift
//  LEARNCAB_STUDENT
//
//  Created by Exarcplus on 27/03/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class GetStartViewController: UIViewController {

    @IBOutlet weak var logbtn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      @IBAction func logbtnpressed(_ sender: UIButton) {
        let mainview = kmainStoryboard.instantiateViewController(withIdentifier: "LoginMobileNoViewController") as! LoginMobileNoViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        self.present(nav, animated:true, completion: nil)

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
