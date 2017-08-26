//
//  DebtInfoViewController.swift
//  Debt Back
//
//  Created by Тимур Фатыхов on 05/08/2017.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

class DebtInfoViewController: UIViewController {

    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var buttonReturned: UIButton!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var textViewNotes: UITextView!
    
    var name : String? = nil
    var photo : UIImage? = nil
    var amount : String? = nil
    var debtManagedObject : NSManagedObject? = nil
    var indexOfSelectedRecord : Int = 0
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let name = debtManagedObject!.value(forKey: "name")
        {
            labelName.text = name as? String
        }
        
        if let sername = debtManagedObject!.value(forKey: "sername")
        {
            labelName.text! += " \(sername as! String)"
        }
        
        if let toMe = debtManagedObject!.value(forKey: "toMe")
        {
            // change debt amount color
            if (!(toMe as! Bool))
            {
                labelAmount.textColor = UIColor.red
                labelAmount.text! = "-"
            }
            else
            {
                labelAmount.text! = ""
            }
        }
        
        if let amount = debtManagedObject!.value(forKey: "amount")
        {
            labelAmount.text! += amount as! String
        }
        
        if let photo = debtManagedObject!.value(forKey: "photo")
        {
            let image = UIImage(data: photo as! Data, scale: 1.0)
            imagePhoto.image = image
            
            imagePhoto.contentMode = .scaleAspectFill
            
            setCircleView(image: imagePhoto)
        }
        else
        {
            imagePhoto.image = #imageLiteral(resourceName: "shapeOfHumanuman128.png")
            
            imagePhoto.contentMode = .scaleAspectFill
            
            setCircleView(image: imagePhoto)
        }
        
        // set notes and phoneNumber
        if let notes = debtManagedObject?.value(forKey: "notes")
        {
            textViewNotes.text = notes as! String
        }
        
        if let number = debtManagedObject?.value(forKey: "phoneNumber")
        {
            labelPhoneNumber.text = number as? String
        }
        
        // delegate
        
    }
    
    func setCircleView(image: UIImageView)
    {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    @IBAction func buttonReturnedClick(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        context.delete(debtManagedObject!)
        
        do
        {
            try context.save()
        }
        catch
        {
            // PROCESS ERROR
        }
        
        self.performSegue(withIdentifier: "debtInfoToDebts", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let controller = segue.destination as? MainTableViewController
        {
            print(indexOfSelectedRecord)
            print(controller.deleteThisVar)
            //controller.debts.remove(at: indexOfSelectedRecord)
        }
        if let navigationVC = segue.destination as? UINavigationController
        {
            let controller = navigationVC.viewControllers.first as! NewDebtViewController
            controller.navigationItem.title = ""
            controller.isNewDebt = false
            controller.managedDebt = debtManagedObject
        }
    }
    
    
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
