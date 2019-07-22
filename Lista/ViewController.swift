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
                save(name: senderVC.itemName, amount: senderVC.amountOfItems)
            }
        }
    }
    
    func save(name: String, amount: Int) {
        let currentDate = Date()
        
        let listEntity = NSEntityDescription.entity(forEntityName: Entity.Name.list, in: managedContext)!
        let newItem = NSManagedObject(entity: listEntity, insertInto: managedContext)
        
        newItem.setValue(name, forKey: Entity.Attribute.itemName)
        newItem.setValue(currentDate, forKey: Entity.Attribute.date)
        newItem.setValue(amount, forKey: Entity.Attribute.amount)
        newItem.setValue(false, forKey: Entity.Attribute.isDone)
        
        coreData.saveContext()
    }
    func mark(item: String, done: Bool) {
//        let managedContext = coreData.persistentContainer.viewContext
        let fetchRequest = List.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "item == %@", item)
        
        do {
            let item = try managedContext.fetch(fetchRequest)
            
            let updateItem = item[0]
            updateItem.isDone = (done) ? false : true
            
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
            
            self.mark(item: item.item, done: item.isDone)
            
            print(item.isDone)
            boolValue(true)
        }
        
        markAsDone.backgroundColor = Color.lime
        let action = UISwipeActionsConfiguration(actions: [markAsDone])
        
        return action
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let item = self.fetchedResultsController.object(at: indexPath)
            self.managedContext.delete(item)
            
            self.coreData.saveContext()
            boolValue(true)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, boolValue) in
            boolValue(true)
//            let editItem = self.fetchedResultsController.object(at: indexPath)
        }
        edit.backgroundColor = Color.cyan
        let actions = UISwipeActionsConfiguration(actions: [delete, edit])
        
        
        return actions
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
        default:
            break
        }
    }
}

//MARK: -  TableView delegates
extension ViewController: UITableViewDelegate {
}
