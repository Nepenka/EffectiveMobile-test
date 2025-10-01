//
//  CoreDataManager.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//

import CoreData
import UIKit



class CoreDataManager {
    static let dataManager = CoreDataManager()
    
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TasksModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveTasks(_ tasks: [Task]) {
        for task in tasks {
            guard let entity = NSEntityDescription.entity(forEntityName: "CDTask", in: context) else {
                print("CoreData entity 'CDTask' not found in model")
                continue
            }
            let cdTask = NSManagedObject(entity: entity, insertInto: context)
            cdTask.setValue(Int32(task.id), forKey: "id")
            cdTask.setValue(task.todo, forKey: "title")
            cdTask.setValue(task.description, forKey: "taskDescription")
            cdTask.setValue(task.completed, forKey: "completed")
            cdTask.setValue(task.date ?? Date(), forKey: "date")
            cdTask.setValue(Int32(task.userId), forKey: "userId")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    func fetchTasks() -> [Task] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDTask")
        do {
            let cdTasks = try context.fetch(request)
            return cdTasks.compactMap { obj in
                let id = (obj.value(forKey: "id") as? Int32).map(Int.init) ?? 0
                let title = obj.value(forKey: "title") as? String ?? ""
                let taskDescription = obj.value(forKey: "taskDescription") as? String
                let completed = obj.value(forKey: "completed") as? Bool ?? false
                let date = obj.value(forKey: "date") as? Date
                let userId = (obj.value(forKey: "userId") as? Int32).map(Int.init) ?? 0
                return Task(
                    id: id,
                    todo: title,
                    description: taskDescription,
                    completed: completed,
                    date: date,
                    userId: userId
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func updateTask(_ task: Task) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDTask")
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            if let cdTask = try context.fetch(request).first {
                cdTask.setValue(task.todo, forKey: "title")
                cdTask.setValue(task.description, forKey: "taskDescription")
                cdTask.setValue(task.completed, forKey: "completed")
                cdTask.setValue(task.date ?? cdTask.value(forKey: "date"), forKey: "date")
                try context.save()
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
}
