//
//  ContactTableViewController.swift
//  MyContacts
//
//  Created by Charles Konkol on 2016-05-05
//  Copyright © 2016 Chuck Konkol. All rights reserved.
//

import UIKit
//0) Add Import Statements for CoreDate and Foundation

//**Begin Copy**
import CoreData
import Foundation
//**End Copy**

//1) Add Delegates to right of UITableViewController
//                    ,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
class ContactTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
//2) Add filter search vars
    
    //**Begin Copy**
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
      var contactArray = [NSManagedObject]()
    //**End Copy**
   
    
//3) Add UISearch func
    
    //**Begin Copy**
    func updateSearchResults(for searchController: UISearchController)
    {
        filteredTableData.removeAll(keepingCapacity: false)
        //search for field in CoreData
        let searchPredicate = NSPredicate(format: "fullname CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactArray as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [NSManagedObject]
    
        self.tableView.reloadData()
    }
    //**End Copy**
    
    
//4) Add variable to hold NSManagedObject
    
    //**Begin Copy**
  
    //**End Copy**
    
    //3) Add viewDidAppear (loads whenever view appears)
    
    //**Begin Copy**
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    //**End Copy**
    
//5) Add func loaddb to load database and refresh table
    
    //**Begin Copy**
    func loaddb()
    {
        
        let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //let fetchRequest = NSFetchRequest(entityName:"Contact")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contact")

            do {
                let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResults {
                    contactArray = results
                    tableView.reloadData()
                } else {
                    print("Could not fetch")
                }
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
            }
    }
    //**End Copy**


    override func viewDidLoad() {
        super.viewDidLoad()
        
//6 Add Search Delegates 
        
    //**Begin Copy**
       self.resultSearchController.delegate = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
           controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    //**End Copy**

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //7) Change to return 1
        
        //**Begin Copy**
        return 1
        //**End Copy**
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //8) Change to return contactArray.count
        
        //**Begin Copy**
        if (self.resultSearchController.isActive) {
            return filteredTableData.count
        }
        else {
            return contactArray.count
        }
        //**End Copy**

    }
    
  //9) Uncomment
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //9a) Change below to load rows
        
         //**Begin Copy**
        if (self.resultSearchController.isActive) {
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
                as UITableViewCell!
            let person = filteredTableData[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "fullname") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
        else {
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
                as UITableViewCell!
            let person = contactArray[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "fullname") as! String?
            cell?.detailTextLabel?.text = ">>"
               return cell!
        }
         //**End Copy**
     
    }

    //10) Add func tableView to show row clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\((indexPath as NSIndexPath).row)")
    }

    //9) Uncomment
    
  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    //10) Uncomment func tableView


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //11 Change to delete swiped row
        
        if editingStyle == .delete {
            let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            if (self.resultSearchController.isActive) {
                context.delete(filteredTableData[(indexPath as NSIndexPath).row])
            }
            else {
                  context.delete(contactArray[(indexPath as NSIndexPath).row])
            }
            
            var error: NSError? = nil
            do {
                try context.save()
                loaddb()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }
 
    }

    
   // 12) Uncomment prepareforseque

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //13) Uncomment & Change to go to proper record on proper Viewcontroller
        
        //**Begin Copy**
        if segue.identifier == "UpdateContacts" {
            if let destination = segue.destination as?
                ViewController {
                    if (self.resultSearchController.isActive) {
                        if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                            let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                             resultSearchController.isActive = false
                        }
                    }
                    else {
                        if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                            let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                        }
                    }
              }
         }
    }
       //**End Copy**

}
