//
//  DetailInteractor.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit
import CoreData


protocol DetailInteractorProtocol: AnyObject {
    func createTask(title: String, description: String, date: Date)
    func updateTask(_ task: Task)
}

final class DetailInteractor: DetailInteractorProtocol {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func createTask(title: String, description: String, date: Date) {
        let newTask = Task(id: Int.random(in: 1000...9999), todo: title, description: description, completed: false, date: date, userId: 0)
        coreDataManager.saveTasks([newTask])
    }
    
    func updateTask(_ task: Task) {
        coreDataManager.updateTask(task)
    }
}

