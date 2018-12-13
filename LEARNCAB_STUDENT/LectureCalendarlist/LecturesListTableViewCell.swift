//
//  LecturesListTableViewCell.swift
//  LearnCab
//
//  Created by Exarcplus on 31/05/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class LecturesListTableViewCell: UITableViewCell {

    @IBOutlet weak var lecturename : UILabel!
    @IBOutlet weak var timelab : UILabel!
    @IBOutlet weak var expairdlab : UILabel!
    @IBOutlet weak var MaxtextLength:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.MaxtextLength.constant = UIScreen.main.bounds.size.height - 78
//        self.lecturename.layoutIfNeeded()
//        self.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
