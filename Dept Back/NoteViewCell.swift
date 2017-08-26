//
//  NoteViewCell.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 11/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell, UITextViewDelegate
{
    
    @IBOutlet weak var textViewNote: UITextView!
    @IBOutlet weak var labelPlaceholder: UILabel!
    
    var tableView: UITableView? = nil
    
    //delegate for change "done" button enabled
    var delegateDone : TextFieldsDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        textViewNote.delegate = self
        
        
        let textViewFrame = CGRect(x: 3, y: 35, width: 369, height: textViewNote.contentSize.height + 10)
        let cellFrame = CGRect(x: 0, y: self.frame.minY, width: self.frame.width, height: textViewFrame.minY + textViewFrame.height + 40.5)
        
        
        textViewNote.frame = textViewFrame
        self.frame = cellFrame
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text != ""
        {
            labelPlaceholder.isHidden = true
        }
        else
        {
            labelPlaceholder.isHidden = false
        }
        
        let tableView = superview?.superview as! UITableView
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        textViewNote.isScrollEnabled = false
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        delegateDone?.buttonEnabledChanged()
    }
}





