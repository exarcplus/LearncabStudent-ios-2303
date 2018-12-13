//
//  SideMenuTableViewCell.swift
//  hello
//
//  Created by Exarcplus on 09/03/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

   
    @IBOutlet weak var Title: UILabel!
    
  
    @IBOutlet weak var imgview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
