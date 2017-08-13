//
//  phoneNumberViewCell.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 08/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit

class PhoneNumberViewCell: UITableViewCell {
    
    @IBOutlet var textFieldPhone : UITextField!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}

extension PhoneNumberViewCell : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textFieldPhone.resignFirstResponder()
        return false
    }
    
}
