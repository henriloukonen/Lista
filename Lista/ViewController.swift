//
//  ViewController.swift
//  Lista
//
//  Created by Henri Loukonen on 11/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, WCSessionDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var isEmptyLabel: UILabel!
    @IBOutlet var noItemsView: UIView!
    @IBOutlet var deleteItems: UIBarButtonItem!
    
    
    private var itemPredicate: NSPredicate?
    private var fetchedResultsController: NSFetchedResultsController<List>!
    var session: WCSession?
    var itemArray: [(String, Int64, Int64)] = []
    
    fileprivate let coreData = CoreDataManager(modelName: "Lista")
    lazy var managedContext = coreData.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
            
        }
        
        title = "Lista"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadSavedItems()
    }
    
    //MARK: - Watch connectivity stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
    //MARK: - Pass items to the watch
    func passPhoneContext() {
        if let validSession = session {
            let request = List.createFetchRequest()
            do {
                let items = try managedContext.fetch(request)
                
                for itemName in items as [List] {
                    if !itemName.isDone {
                        itemArray += [(itemName.item, itemName.amount, itemName.tag)]
                        print(itemArray[0])
                    }
                }
                
                let infoToPass = ["items" : itemArray]
                validSession.transferUserInfo(infoToPass)
            } catch {
                print("failed to fetch items")
            }
        }
    }
    
    
    //MARK: - Unwind from ItemViewController and add new item
    @IBAction func unwindFromAddItemVC(_ sender: UIStoryboardSegue) {
        if sender.source is ItemViewController {
            if let senderVC = sender.source as? ItemViewController {
                if senderVC.passedItem != nil {
                    updateItem(oldName: senderVC.oldName, newName: senderVC.newName, newAmount: senderVC.amountOfItems, newTag: senderVC.selectedTag)
                } else {
                    saveNewItem(name: senderVC.newName, amount: senderVC.amountOfItems, tag: senderVC.selectedTag)
                }
            }
        }
    }
    
    //MARK: - Save and load items
    func saveNewItem(name: String, amount: Int64, tag: Int64) {
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
    func loadSavedItems() {
        if fetchedResultsController == nil {
            let request = List.createFetchRequest()
            
            let sortAllByTag = NSSortDescriptor(key: Entity.Attribute.tag, ascending: false)
            let sortAllByDate = NSSortDescriptor(key: Entity.Attribute.date, ascending: true)
            request.sortDescriptors = [sortAllByTag, sortAllByDate]
            request.fetchBatchSize = 30
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: Entity.Attribute.tag, cacheName: nil)
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

    
    //MARK: - update item details
    func updateItem(oldName: String, newName: String, newAmount: Int64, newTag: Int64?) {
        let fetchRequest = List.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "item == %@", oldName)
        
        do {
            let item = try managedContext.fetch(fetchRequest)
            if newName     !=  oldName        { item[0].item   = newName }
            if newAmount   !=  item[0].amount { item[0].amount = newAmount }
            if newTag      !=  item[0].tag    { item[0].tag    = newTag! }
            
            coreData.saveContext()
        } catch {
            print(error)
        }
    }
    
    //MARK: - mark item as done
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
    
    //MARK: - Delete done or every item
    @IBAction func editItems(_ sender: Any) {
        let deleteAll = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        deleteAll.addAction(UIAlertAction(title: "Delete all", style: .destructive, handler: { action in
            self.deleteAllItems()
        }))
        deleteAll.addAction(UIAlertAction(title: "Clear done items", style: .default, handler: { action in
            self.clearDoneItems()
        }))
        
        deleteAll.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(deleteAll, animated: true)
    }
    
    func clearDoneItems() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        fetch.predicate = NSPredicate(format: "isDone == true")
        
        do {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            let result = try self.managedContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result.result as! [NSManagedObjectID]]
            
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.managedContext])
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
    
    func deleteAllItems() {
        let confirmDelete = UIAlertController(title: "This action cannot be undone", message: nil, preferredStyle: .actionSheet)
        confirmDelete.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { action in
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            
            do {
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                batchDeleteRequest.resultType = .resultTypeObjectIDs
                
                let result = try self.managedContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result.result as! [NSManagedObjectID]]
                
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.managedContext])
            } catch {
                fatalError("Failed to execute request: \(error)")
            }
        }))
        confirmDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmDelete, animated: true)
    }
}

//MARK: - TableView DataSource extension
extension ViewController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        
        let sectionInfo = fetchedResultsController.sections?.count
        tableView.backgroundView = (sectionInfo==0) ? noItemsView : nil
        deleteItems.isEnabled = (sectionInfo==0) ? false : true
        
        return sectionInfo ?? 0
    }
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        let rows = sectionInfo.numberOfObjects
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
            
            self.mark(itemName: item.item, done: item.isDone)
            
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
    
    //MARK: - FetchedResultControllers
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let index = IndexSet(integer: sectionIndex)

        switch type {
        case .delete:
            tableView.deleteSections(index, with: .left)
        case .insert:
            tableView.insertSections(index, with: .bottom)
        case .update:
            tableView.reloadSections(index, with: .fade)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .bottom)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
}

//MARK: -  TableView delegates extension
extension ViewController: UITableViewDelegate {

}

