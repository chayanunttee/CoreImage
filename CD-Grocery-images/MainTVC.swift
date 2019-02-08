//
//  MainTVC.swift
//  CD-Grocery-Images
//
//  Created by Jason Rybka on 8/16/15.
//  Copyright © 2015 Jason Rybka. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var frc : NSFetchedResultsController =  NSFetchedResultsController()
    
    lazy var frc: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest(), managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
        
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = getFRC()
        frc.delegate = self
        
        do {
            try self.frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        
        self.tableView.rowHeight = 60
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "orange-bg"))
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        
        return numberOfRowsInSection!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        }
        
        // Configure the cell...
        
        cell.textLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.textColor = UIColor.darkGray
        
        let item = frc.object(at: indexPath as IndexPath) as! Item
        cell.textLabel?.text = item.name
        let phone = item.phone
        cell.detailTextLabel!.text = "phone: \(phone!)"
        cell.imageView?.image = UIImage(data: (item.image)! as Data)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let managedObject : NSManagedObject = frc.object(at: indexPath as IndexPath) as! NSManagedObject
        moc.delete(managedObject)
        
        do {
            try moc.save()
        } catch {
            print("Failed to save.")
            return
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let itemController : AddEditVC = segue.destination as! AddEditVC
            let item : Item = frc.object(at: indexPath!) as! Item
            itemController.item = item
        }
    }
}
