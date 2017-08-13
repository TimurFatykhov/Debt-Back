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
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var buttonReturned: UIButton!
    
    var name : String? = nil
    var photo : UIImage? = nil
    var amount : String? = nil
    var debtManagedObject : NSManagedObject? = nil
    var indexOfSelectedRecord : Int = 0
    
    override func viewWillAppear(_ animated: Bool)
    {
        labelName.text = name!
        labelAmount.text = amount!
        imagePhoto.image = photo!
        
        imagePhoto.contentMode = .scaleAspectFill
        
        setCircleView(image: imagePhoto)
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
