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
    @IBOutlet var selectButton: UIBarButtonItem!
    
    private var itemPredicate: NSPredicate?
    private var fetchedResultsController: NSFetchedResultsController<List>!
    
    fileprivate let coreData = CoreDataManager(modelName: "Lista")
    
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

    func loadSavedItems() {
        if fetchedResultsController == nil {
            let request = List.createFetchRequest()
//            let sortByTag = NSSortDescriptor(key: ListKeys.tag, ascending: false)
            let sortAllByDate = NSSortDescriptor(key: EntityKey.date, ascending: true)
            request.sortDescriptors = [sortAllByDate]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: EntityKey.date, cacheName: nil)
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
    
    @IBAction func selectItems(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        selectButton.title? = tableView.isEditing ? "Cancel" : "Select"
    }
    
    func save(name: String, amount: Int) {
        let currentDate = Date()
        
        let listEntity = NSEntityDescription.entity(forEntityName: EntityKey.listEntity, in: coreData.persistentContainer.viewContext)!
        let newItem = NSManagedObject(entity: listEntity, insertInto: coreData.persistentContainer.viewContext)
        
//        let tagEntity = NSEntityDescription.entity(forEntityName: EntityKey.tagEntity, in: coreData.persistentContainer.viewContext)!
//        let newTagColor = NSManagedObject(entity: tagEntity, insertInto: coreData.persistentContainer.viewContext)
        
        newItem.setValue(name, forKey: EntityKey.itemName)
        newItem.setValue(currentDate, forKey: EntityKey.date)
        newItem.setValue(amount, forKey: EntityKey.amount)
        
//        newTagColor.setValue(tag, forKey: "color")
        
        coreData.saveContext()
    }
}

//MARK: - TableViews
extension ViewController: UITableViewDataSource {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let index = IndexSet(integer: sectionIndex)
        
        switch type {
        case .delete:
            tableView.deleteSections(index, with: .left)
        case .insert:
            tableView.insertSections(index, with: .top)
        default:
            break
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = fetchedResultsController.sections?.count
        
        if sections == 0 {
            tableView.backgroundView = noItemsView
            selectButton.isEnabled = false
            
        } else {
            tableView.backgroundView = nil
            selectButton.isEnabled = true
        }
        return sections ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections![section].name
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        
       
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let index = fetchedResultsController.object(at: indexPath)
        
        cell.configureCell(from: index)
        
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            boolValue(true)
            let item = self.fetchedResultsController.object(at: indexPath)
            self.coreData.persistentContainer.viewContext.delete(item)
            self.coreData.saveContext()
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, boolValue) in
            boolValue(true)
            let editItem = self.fetchedResultsController.object(at: indexPath)
        }
        
        let done = UISwipeActionsConfiguration(actions: [delete, edit])
        edit.backgroundColor = Color.cyan
        
        return done
    }
}

extension ViewController: UITableViewDelegate {

}
