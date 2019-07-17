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

    
    func loadSavedItems() {
        if fetchedResultsController == nil {
            let request = List.createFetchRequest()
            let sortByDate = NSSortDescriptor(key: ListKeys.category, ascending: false)
            request.sortDescriptors = [sortByDate]
        
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreData.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
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
        selectButton.title? = tableView.isEditing ? "Done" : "Edit"
    }
    
    func save(with name: String, category: String) {
        let currentDate = Date()
        let entity = NSEntityDescription.entity(forEntityName: ListKeys.listName, in: coreData.persistentContainer.viewContext)!
        let item = NSManagedObject(entity: entity, insertInto: coreData.persistentContainer.viewContext)
        
        item.setValue(name, forKey: ListKeys.itemName)
        item.setValue(currentDate, forKey: ListKeys.date)
        item.setValue(category, forKey: ListKeys.category)
        coreData.saveContext()
    }
    
    @IBAction func unwindFromAddItemVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddItemViewController {
            if let senderVC = sender.source as? AddItemViewController {
                save(with: senderVC.itemName, category: senderVC.category)
            }
        }
    }
}
extension ViewController: UITableViewDataSource {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .top)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Color.cyan
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections![section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        if sectionInfo.numberOfObjects == 0 {
            tableView.backgroundView = noItemsView
            tableView.separatorStyle = .none
          
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let index = fetchedResultsController.object(at: indexPath)
        let categoryColor = index.category
        
        cell.configureCell(from: index, with: categoryColor)
        
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
