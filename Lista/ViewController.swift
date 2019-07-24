//
//  ViewController.swift
//  Lista
//
//  Created by Henri Loukonen on 11/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var isEmptyLabel: UILabel!
    @IBOutlet var noItemsView: UIView!
    
    private var itemPredicate: NSPredicate?
    private var fetchedResultsController: NSFetchedResultsController<List>!
    
    fileprivate let coreData = CoreDataManager(modelName: "Lista")
    lazy var managedContext = coreData.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lista"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadSavedItems()
    }
    
    @IBAction func unwindFromAddItemVC(_ sender: UIStoryboardSegue) {
        if sender.source is ItemViewController {
            if let senderVC = sender.source as? ItemViewController {
                if senderVC.passedItem != nil {
                    updateItem(oldName: senderVC.oldName, newName: senderVC.newName, newAmount: senderVC.amountOfItems, newTag: senderVC.selectedTag)
                } else {
                    save(name: senderVC.oldName, amount: senderVC.amountOfItems, tag: senderVC.selectedTag)
                }
            }
            
        }
    }
    
    func save(name: String, amount: Int64, tag: Int64) {
        let currentDate = Date()
        
        let listEntity = NSEntityDescription.entity(forEntityName: Entity.Name.list, in: managedContext)!
        let newItem = NSManagedObject(entity: listEntity, insertInto: managedContext)
        
        newItem.setValue(name, forKey: Entity.Attribute.itemName)
        newItem.setValue(currentDate, forKey: Entity.Attribute.date)
        newItem.setValue(amount, forKey: Entity.Attribute.amount)
        newItem.setValue(tag, forKey: Entity.Attribute.tag)
        newItem.setValue(false, forKey: Entity.Attribute.isDone)
        
        coreData.saveContext()
    }
    func updateItem(oldName: String, newName: String, newAmount: Int64, newTag: Int64) {
        let fetchRequest = List.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "item == %@", oldName)
        
        do {
            
            let item = try managedContext.fetch(fetchRequest)
            if newName !=  oldName { item[0].item = newName }
            if newAmount != item[0].amount { item[0].amount = newAmount }
//            if item[0].tag    != newTag    { item[0].tag = newTag }
            tableView.reloadData()
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    func mark(itemName: String, done: Bool) {
        let fetchRequest = List.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "item == %@", itemName)
        
        do {
            let item = try managedContext.fetch(fetchRequest)
            item[0].isDone = (done) ? false : true
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
   
    
    
    func loadSavedItems() {
        if fetchedResultsController == nil {
            let request = List.createFetchRequest()
            
            let sortAllByDate = NSSortDescriptor(key: Entity.Attribute.date, ascending: true)
            request.sortDescriptors = [sortAllByDate]
            request.fetchBatchSize = 30
           
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        fetchedResultsController.fetchRequest.predicate = itemPredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("fetch failed")
        }
    }
    @IBAction func edit(_ sender: Any) {
        tableView.setEditing(true, animated: true)
    }
}

//MARK: - TableViews
extension ViewController: UITableViewDataSource {
//    func numberOfRowsSections(in tableView: UITableView) -> Int {
//
//
//        return sections ?? 0
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return fetchedResultsController.sections![section].name
//
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        let rows = sectionInfo.numberOfObjects
        tableView.backgroundView = (rows==0) ? noItemsView : nil
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let index = fetchedResultsController.object(at: indexPath)
        
        cell.configureCell(from: index)

        return cell
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsDone = UIContextualAction(style: .normal, title: "Done") { (contextualAction, view, boolValue) in
            
            let item = self.fetchedResultsController.object(at: indexPath)
            let cell = self.tableView.cellForRow(at: indexPath) as! ItemTableViewCell
            
            self.mark(itemName: item.item, done: item.isDone)
            cell.animateDoneItem(using: item.isDone)
            
            boolValue(true)
        }
        markAsDone.image = UIImage(named: "checkmark.png")
        markAsDone.backgroundColor = Color.lime
        let action = UISwipeActionsConfiguration(actions: [markAsDone])
        
        return action
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let item = self.fetchedResultsController.object(at: indexPath)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            
            self.managedContext.delete(item)
            self.coreData.saveContext()
            boolValue(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, boolValue) in
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "itemVC") as! ItemViewController
                editVC.passedItem = item
//                            let transition = CATransition()
//                            transition.duration = 0.5
//                            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//                            transition.type = .push
//                            transition.subtype = .fromTop
//                            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                self.navigationController?.pushViewController(editVC, animated: true)
            
            boolValue(true)
        }
            edit.backgroundColor = Color.cyan
        
        if item.isDone {
            let actions = UISwipeActionsConfiguration(actions: [delete])
            return actions
        } else {
            let actions = UISwipeActionsConfiguration(actions: [delete, edit])
            return actions
        }
    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        let index = IndexSet(integer: sectionIndex)
//
//        switch type {
//        case .delete:
//
//            coreData.saveContext()
//            tableView.deleteSections(index, with: .left)
//            print("\(index) deleted")
//
//        case .insert:
//            coreData.saveContext()
//            tableView.insertSections(index, with: .fade)
//            print("\(index) added")
//        default:
//            break
//        }
//    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            print("deleted")
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .top)
            }
            print("added")
        case .update:
            if indexPath != nil{
                
            }
        default:
            break
        }
    }
}

//MARK: -  TableView delegates
extension ViewController: UITableViewDelegate {

}

