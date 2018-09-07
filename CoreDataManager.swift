//
//  CoreDataManager.swift
//  Intermediate App
//
//  Created by Jose L Sanchez on 6/9/18.
//  Copyright © 2018 Jose L Sanchez. All rights reserved.
// CMD + control + e to change name of instances

import CoreData



struct CoreDataManager {
    
    static let shared = CoreDataManager()  //will live for ever as long is still alive and its properties will too
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "IntermediateTrainingModel")
        
        container.loadPersistentStores {
            (storeDescription, err) in if let err = err {
                fatalError("Loading of store failed \(err)")
            }
        }
        
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            return companies
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
        
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        
        //create employee object
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            
            return nil
        } catch let err {
            print("Failed to create employee: ", err)
            return err
        }
        
        
        
    }
    
}



