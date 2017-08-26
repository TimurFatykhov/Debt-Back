//
//  phoneNumberViewCell.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 08/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberViewCell: UITableViewCell, UITextViewDelegate
{
    @IBOutlet weak var textFieldPhone: UITextField!
    var phoneKit = PhoneNumberKit()
    
    // delegate for interact with "done" button
    var delegateDone : TextFieldsDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        textFieldPhone.delegate = self as? UITextFieldDelegate
    }

    @IBAction func editingChanged(_ sender: UITextField)
    {
        sender.text = PartialFormatter().formatPartial(sender.text!)
        delegateDone?.buttonEnabledChanged()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textFieldPhone.resignFirstResponder()
        return false
    }
}

