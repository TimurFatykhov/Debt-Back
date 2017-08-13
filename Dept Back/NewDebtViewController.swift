//
//  newDebtViewController.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 08/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

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

class NewDebtViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet var newDebtView: UITableView!
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    
    var imageSelected = false
    let imagePicker = UIImagePickerController()
    
    //define cell for control main info
    var mainInfoCell : MainInfoViewCell? = nil
    
    var debtsListView : UITableViewController? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        newDebtView.delegate = self
        
        newDebtView.rowHeight = UITableViewAutomaticDimension
        newDebtView.estimatedRowHeight = 100
        
        newDebtView.tableFooterView = UIView()
        
        newDebtView.alwaysBounceVertical = false
        
        self.hideKeyboardWhenTappedAround()
        
        imagePicker.delegate = self
        
        //define cell
        mainInfoCell = newDebtView.dequeueReusableCell(withIdentifier: "mainInfoCell")! as? MainInfoViewCell
        mainInfoCell!.buttonDone = buttonDone
        
        // set tap recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainInfoCell!.imagePhoto.isUserInteractionEnabled = true
        mainInfoCell!.imagePhoto.addGestureRecognizer(tapGestureRecognizer)
       }
    
    @IBAction func clickCancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
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
        case 1: return newDebtView.dequeueReusableCell(withIdentifier: "phoneNumberCell")! as! PhoneNumberViewCell
        case 2: return  newDebtView.dequeueReusableCell(withIdentifier: "noteCell")! as! NoteViewCell
        default: return  newDebtView.dequeueReusableCell(withIdentifier: "phoneNumberCell")! as! PhoneNumberViewCell
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newDebt = NSEntityDescription.insertNewObject(forEntityName: "Debt", into: context)
        
        
        newDebt.setValue(mainInfoCell!.textName.text, forKey: "name")
        newDebt.setValue(mainInfoCell!.textSername.text, forKey: "sername")
        newDebt.setValue(mainInfoCell!.textDebtsAmount.text, forKey: "amount")
        
        if (imageSelected)
        {
            let photo = UIImageJPEGRepresentation(mainInfoCell!.imagePhoto.image!, 0)
            newDebt.setValue(photo, forKey: "photo")
        }
        
        if (mainInfoCell!.segmentedControlWhom.selectedSegmentIndex == 0)
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
        
        dismiss(animated: true)
        {
            
        }
    }

}












