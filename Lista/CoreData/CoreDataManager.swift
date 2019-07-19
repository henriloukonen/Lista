//
//  CoreDataManager.swift
//  Lista
//
//  Created by Henri Loukonen on 12/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//

import CoreData

final class CoreDataManager {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)") // Replace this implementation with code to handle the error appropriately.
            }
        })
        return container
    }()
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("CHANGES SAVED")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)") // Replace this implementation with code to handle the error appropriately.
            }
        }
    }
}

