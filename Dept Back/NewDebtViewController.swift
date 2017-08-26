//
//  newDebtViewController.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 08/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

protocol TextFieldsDelegate
{
    var defaultName     : String {get set}
    var defaultSername  : String {get set}
    var defaultAmount   : String {get set}
    var defaultNumber   : String {get set}
    var defaultNote     : String {get set}
    var defaultWhomIndex: Int    {get set}
    
    
    func buttonEnabledChanged()
}

extension UITableViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        tableView.endEditing(true)
    }
}

class NewDebtViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, TextFieldsDelegate
{
    // MARK: - properties
    
    @IBOutlet var newDebtView: UITableView!
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // define variables for interact with coreData
    var appDelegate : AppDelegate
    var context : NSManagedObjectContext
    var managedDebt : NSManagedObject?
    var isNewDebt = true
    
    // for image picker
    var imageSelected = false
    let imagePicker = UIImagePickerController()
    
    // define cells
    var mainInfoCell : MainInfoViewCell? = nil
    var phoneNumberCell : PhoneNumberViewCell? = nil
    var notesCell : NoteViewCell? = nil
    
    var debtsListView : UITableViewController? = nil    
    
    
    // meet the condition of delegate protocol
    var defaultName: String = ""
    var defaultNote: String = ""
    var defaultAmount: String = ""
    var defaultNumber: String = ""
    var defaultSername: String = ""
    var defaultWhomIndex: Int = 0
    
    
    // MARK: - methods
    
    required init?(coder aDecoder: NSCoder)
    {
        //fatalError("init(coder:) has not been implemented")
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        newDebtView.delegate = self
        imagePicker.delegate = self
        
        newDebtView.alwaysBounceVertical = false
        
        self.hideKeyboardWhenTappedAround()
        
        // hack for deleting extra separators
        newDebtView.tableFooterView = UIView()
        
        //define cells
        mainInfoCell = newDebtView.dequeueReusableCell(withIdentifier: "mainInfoCell")! as? MainInfoViewCell
        mainInfoCell!.buttonDone = buttonDone
        phoneNumberCell = newDebtView.dequeueReusableCell(withIdentifier: "phoneNumberCell")! as? PhoneNumberViewCell
        notesCell = newDebtView.dequeueReusableCell(withIdentifier: "noteCell") as? NoteViewCell
        
        //link delegate for this cells
        mainInfoCell?.delegateDone = self
        phoneNumberCell?.delegateDone = self
        notesCell?.delegateDone = self
        
        // set tap recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainInfoCell!.imagePhoto.isUserInteractionEnabled = true
        mainInfoCell!.imagePhoto.addGestureRecognizer(tapGestureRecognizer)
        
        // for cells autosize
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 70;
        
        // define managedObject
        if (managedDebt == nil) // user create new debt
        {
            managedDebt = NSEntityDescription.insertNewObject(forEntityName: "Debt", into: context)
        }
        else                    // user want to edit exist debt
        {
            if let name = managedDebt!.value(forKey: "name")
            {
                mainInfoCell?.textName!.text = name as? String
                defaultName = name as! String
            }
            
            if let sername = managedDebt!.value(forKey: "sername")
            {
                mainInfoCell?.textSername!.text = sername as? String
                defaultSername = sername as! String
            }
            
            if let toMe = managedDebt!.value(forKey: "toMe") as? Bool
            {
                // change debt amount color
                if (!toMe)
                {
                    mainInfoCell?.segmentedControlWhom.selectedSegmentIndex = 1
                    defaultWhomIndex = 1
                }
            }
            
            if let amount = managedDebt!.value(forKey: "amount")
            {
                mainInfoCell?.textDebtsAmount.text = amount as? String
                defaultAmount = amount as! String
            }
            
            if let photo = managedDebt!.value(forKey: "photo")
            {
                let image = UIImage(data: photo as! Data, scale: 1.0)
                mainInfoCell?.imagePhoto.image = image
                
                mainInfoCell?.imagePhoto.contentMode = .scaleAspectFill
                
                setCircleView(image: mainInfoCell!.imagePhoto)
            }
            else
            {
                mainInfoCell?.imagePhoto.image = #imageLiteral(resourceName: "shapeOfHumanuman128.png")
                
                mainInfoCell?.imagePhoto.contentMode = .scaleAspectFill
                
                setCircleView(image: mainInfoCell!.imagePhoto)
            }
            
            // set notes and phoneNumber
            if let notes = managedDebt!.value(forKey: "notes")
            {
                notesCell?.textViewNote.text = notes as! String
                notesCell?.labelPlaceholder.isHidden = true
                defaultNote = notes as! String
            }
            
            if let number = managedDebt!.value(forKey: "phoneNumber")
            {
                phoneNumberCell?.textFieldPhone.text = number as? String
                defaultNumber = number as! String
            }
        }
       }
    
    @IBAction func clickCancel(_ sender: Any)
    {
        if (isNewDebt)
        {
            context.delete(managedDebt!)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    // meet the protocols condition
    func buttonEnabledChanged()
    {
        if  (mainInfoCell?.textName.text != defaultName)            ||
            (mainInfoCell?.textSername.text != defaultSername)      ||
            (mainInfoCell?.textDebtsAmount.text != defaultAmount)   ||
            (phoneNumberCell?.textFieldPhone.text != defaultNumber) ||
            (notesCell?.textViewNote.text != defaultNote)           ||
            (mainInfoCell?.segmentedControlWhom.selectedSegmentIndex != defaultWhomIndex)
        {
            buttonDone.isEnabled = true
        }
        else
        {
            buttonDone.isEnabled = false
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch (indexPath.row)
        {
        case 0: return mainInfoCell!
        case 1: return phoneNumberCell!
        case 2: return notesCell!
        default: return notesCell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        newDebtView.deselectRow(at: indexPath, animated: true)
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
        mainInfoCell!.imagePhoto.image = chosenImage
        setCircleView(image: mainInfoCell!.imagePhoto)
        mainInfoCell!.imagePhoto.contentMode = .scaleAspectFill
        dismiss(animated:true, completion: nil)
        imageSelected = true
    }
    
    // "cancel" tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func setCircleView(image: UIImageView)
    {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    // MARK: - Save debt
    
    @IBAction func buttonDoneClick(_ sender: Any)
    {
        managedDebt!.setValue(mainInfoCell!.textName.text, forKey: "name")
        managedDebt!.setValue(mainInfoCell!.textSername.text, forKey: "sername")
        managedDebt!.setValue(mainInfoCell!.textDebtsAmount.text, forKey: "amount")
        managedDebt!.setValue(phoneNumberCell!.textFieldPhone.text, forKey: "phoneNumber")
        managedDebt!.setValue(notesCell!.textViewNote.text, forKey: "notes")
        
        if (imageSelected)
        {
            let photo = UIImageJPEGRepresentation(mainInfoCell!.imagePhoto.image!, 0)
            managedDebt!.setValue(photo, forKey: "photo")
        }
        
        if (mainInfoCell!.segmentedControlWhom.selectedSegmentIndex == 0)
        {
            managedDebt!.setValue(true, forKey: "toMe")
        }
        else
        {
            managedDebt!.setValue(false, forKey: "toMe")
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
        
        dismiss(animated: true)
    }
}












