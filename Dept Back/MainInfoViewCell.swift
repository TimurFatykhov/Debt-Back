//
//  mainInfoCell.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 08/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

class MainInfoViewCell: UITableViewCell
{
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var textDebtsAmount: UITextField!
    @IBOutlet weak var textSername: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var segmentedControlWhom: UISegmentedControl!
    
    var buttonDone : UIBarButtonItem? = nil
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        textSername.delegate = self
        textName.delegate = self
        textDebtsAmount.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK : - Input text information
    func buttonEnabledChanged()
    {
        buttonDone!.isEnabled = !(textName.text?.characters.isEmpty)!          ||
            !(textSername.text?.characters.isEmpty)!       ||
            !(textDebtsAmount.text?.characters.isEmpty)!
    }
    
    @IBAction func nameEditingChanged(_ sender: Any)
    {
        buttonEnabledChanged()
    }
    
    @IBAction func sernameEditingChanged(_ sender: Any)
    {
        buttonEnabledChanged()
    }
    
    @IBAction func amountEditingChanged(_ sender: Any)
    {
        buttonEnabledChanged()
    }

}


extension MainInfoViewCell : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case textName:
            textSername.becomeFirstResponder()
        case textSername:
            textDebtsAmount.becomeFirstResponder()
        case textDebtsAmount:
            textDebtsAmount.resignFirstResponder()
        default:
            break
        }
        return false
    }

}





