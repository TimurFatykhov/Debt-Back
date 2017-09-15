//
//  DebtViewCell.swift
//  Debt Back
//
//  Created by Educational on 02/06/17.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit

class DebtViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelInitials: UILabel!
    var index : Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
