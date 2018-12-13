//
//  ViewController.swift
//  LEARNCAB_STUDENT
//
//  Created by Exarcplus on 3/20/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
     @IBOutlet weak var  collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        return cell;
    }
    
  
}

