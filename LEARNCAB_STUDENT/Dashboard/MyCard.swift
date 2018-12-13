//
//  MyCard.swift
//  LearnCab
//
//  Created by Exarcplus on 21/06/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import WOWCardStackView

class MyCard: CardView {
    @IBOutlet weak var coursename : UILabel!
    @IBOutlet weak var level : UILabel!
    @IBOutlet weak var datelab : UILabel!
    
    var id: Int
    
    init(id: Int) {
        self.id = id
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = 0
        super.init(coder: aDecoder)
    }
    
}
