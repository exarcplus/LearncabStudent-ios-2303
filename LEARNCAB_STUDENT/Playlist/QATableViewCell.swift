//
//  QATableViewCell.swift
//  JJS
//
//  Created by Exarcplus on 09/10/17.
//  Copyright © 2017 Exarcplus. All rights reserved.
//

import UIKit

class QATableViewCell: UITableViewCell {
    
    @IBOutlet var namelable: UILabel!
    @IBOutlet var logoimg : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
