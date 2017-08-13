//
//  NoteViewCell.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 11/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell
{
    @IBOutlet var textViewNotes : UITextView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        let amountOfLinesToBeShown : CGFloat = 10
        let maxHeight : CGFloat = amountOfLinesToBeShown * textViewNotes.font!.lineHeight
        let size = CGSize(width: textViewNotes.frame.width, height: maxHeight)
        textViewNotes.sizeThatFits(size)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        
    }

}
