//
//  NewDebtController.swift
//  Debt Back
//
//  Created by Educational on 04/06/17.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

//class Debtor : NSObject, NSCoding
//{
//    var name : String!
//    var sername : String!
//    var amount : Int!
//    
//    required convenience init(coder decoder: NSCoder)
//    {
//        self.init()
//        self.name = decoder.decodeObject(forKey: "name") as? String
//        self.sername = decoder.decodeObject(forKey: "sername") as? String
//        self.amount = decoder.decodeObject(forKey: "amount") as? Int
//    }
//    
//    func encode(with coder: NSCoder)
//    {
//        coder.encodeConditionalObject(name, forKey: "name")
//        coder.encodeConditionalObject(sername, forKey: "sername")
//        coder.encodeConditionalObject(amount, forKey: "amount")
//    }
//}

//extension UIViewController
//{
//    func hideKeyboardWhenTappedAround()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard()
//    {
//        view.endEditing(true)
//    }
//}

class NewDebtController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var textDebtsAmount: UITextField!
    @IBOutlet weak var textSername: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var segmentedControlWhom: UISegmentedControl!
    
    var imageSelected = false
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        //self.hideKeyboardWhenTappedAround()
    
        // set tap recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagePhoto.isUserInteractionEnabled = true
        imagePhoto.addGestureRecognizer(tapGestureRecognizer)
        
        // fileManager
//        let fileMngr = FileManager.default
//        let dirPaths = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)
//        let docsDir = dirPaths.last!.path // *or first* ,bacause only one result of search at previous string
    }

    // MARK: - Choose image
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePhoto.image = chosenImage
        setCircleView(image: imagePhoto)
        imagePhoto.contentMode = .scaleAspectFill
        dismiss(animated:true, completion: nil)
        imageSelected = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func setCircleView(image: UIImageView)
    {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    
    // MARK: - Edit text info
    func buttonEnabledChanged()
    {
        buttonDone.isEnabled = !(textName.text?.characters.isEmpty)! || !(textSername.text?.characters.isEmpty)!
                                                                     || !(textDebtsAmount.text?.characters.isEmpty)!
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
    
    
    // MARK: - Save debt
    
    @IBAction func buttonDoneClick(_ sender: Any)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newDebt = NSEntityDescription.insertNewObject(forEntityName: "Debt", into: context)
        
        
        newDebt.setValue(textName.text, forKey: "name")
        newDebt.setValue(textSername.text, forKey: "sername")
        newDebt.setValue(textDebtsAmount.text, forKey: "amount")
        
        if (imageSelected)
        {
            let photo = UIImageJPEGRepresentation(imagePhoto.image!, 0)
            newDebt.setValue(photo, forKey: "photo")
        }
        
        if (segmentedControlWhom.selectedSegmentIndex == 0)
        {
            newDebt.setValue(true, forKey: "toMe")
        }
        else
        {
            newDebt.setValue(false, forKey: "toMe")
        }
        
        do
        {
            try context.save()
            print("SAVED!")
        }
        catch
        {
            // PROCESS ERROR
        }
        
        self.performSegue(withIdentifier: "newDebtToDebts", sender: nil)
    }
}







