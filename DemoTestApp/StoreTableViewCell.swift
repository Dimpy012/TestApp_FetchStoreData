//
//  StoreTableViewCell.swift
//  DemoTestApp
//
//  Created by Dimpy Patel on 19/06/25.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
