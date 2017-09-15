//
//  MainTableViewController.swift
//  Debt Back
//
//  Created by Educational on 02/06/17.
//  Copyright © 2017 Educational. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    @IBOutlet var mainTable: UITableView!
    
    var indexOfSelectedRecord : Int = 0
    var debts : [NSManagedObject] = []
    
    var deleteThisVar : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Circle image
        mainTable.rowHeight = UITableViewAutomaticDimension
        mainTable.estimatedRowHeight = 100
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // CoreData's instruments
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
        request.returnsObjectsAsFaults = false
        
        // Obtain debts
        do
        {
            debts = try context.fetch(request) as! [NSManagedObject]
        }
        catch
        {
            // PROCESS ERROR
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return debts.count
    }
    
    func setCircleView(image: UIImageView)
    {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = mainTable.dequeueReusableCell(withIdentifier: "Debt")! as! DebtViewCell
        
        let debt = debts[indexPath.row]
        
        if let name = debt.value(forKey: "name")
        {
            cell.labelName.text! = name as! String
        }
        
        if let sername = debt.value(forKey: "sername")
        {
            cell.labelName.text! += " \(sername as! String)"
        }
        
        if let toMe = debt.value(forKey: "toMe")
        {
            // change debt amount color
            if (!(toMe as! Bool))
            {
                cell.labelAmount.textColor = UIColor.gray
                cell.labelAmount.text! = "-"
            }
            else
            {
                cell.labelAmount.textColor = UIColor.gray
                cell.labelAmount.text! = ""
            }
        }
        
        if let amount = debt.value(forKey: "amount")
        {
            cell.labelAmount.text! += amount as! String
        }
        
        if let photo = debt.value(forKey: "photo")
        {
            let image = UIImage(data: photo as! Data, scale: 1.0)
            cell.imagePhoto.image = image
            cell.labelInitials.isHidden = true
        }
        else
        {
            if let initials = debt.value(forKey: "initials")
            {
                cell.imagePhoto.backgroundColor = UIColor.gray
                cell.labelInitials.text = initials as? String
            }
            else
            {
                //cell.imagePhoto.image = #imageLiteral(resourceName: "shapeOfHumanuman128.png")
                cell.labelInitials.isHidden = true
            }
            
        }
        
        cell.index = indexPath.row
        
        setCircleView(image: cell.imagePhoto)
        cell.imagePhoto.contentMode = .scaleAspectFill
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        mainTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let controller = segue.destination as? DebtInfoViewController
        {
            controller.amount = (sender as! DebtViewCell).labelAmount.text
            controller.name = (sender as! DebtViewCell).labelName.text
            controller.photo = (sender as! DebtViewCell).imagePhoto.image
            
            let index = (sender as! DebtViewCell).index
            controller.indexOfSelectedRecord = index!
            controller.debtManagedObject = debts[index!]
            deleteThisVar = debts.count
        }
        
        if let controller = segue.destination as? NewDebtViewController
        {
            controller.debtsListView = self
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
