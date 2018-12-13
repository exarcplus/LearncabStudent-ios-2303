//
//  QandATableViewCell.swift
//  LearnCab
//
//  Created by Exarcplus on 29/05/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class QandATableViewCell: UITableViewCell {

    @IBOutlet weak var profileimg : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var questionLable : UILabel!
    @IBOutlet weak var webView1: UILabel!
    @IBOutlet var detailsheight : NSLayoutConstraint!
    @IBOutlet weak var statusLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.detailswebviewheight.constant = webView1.scrollView.contentSize.height
//        self.webView1.layoutIfNeeded()
//        self.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
