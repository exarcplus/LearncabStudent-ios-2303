//
//  LecturesDetailsTableViewCell.swift
//  LearnCab
//
//  Created by Exarcplus on 20/04/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class LecturesDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Lcname : UILabel!
    @IBOutlet weak var fcname : UILabel!
    @IBOutlet weak var Lcimg : UIImageView!
    @IBOutlet weak var lctime : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
