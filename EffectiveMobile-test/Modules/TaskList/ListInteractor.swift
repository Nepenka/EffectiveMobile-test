//
//  ListInteractor.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit


protocol ListInteractorProtocool: AnyObject {
    func fetchTasks()
    func updateTask(_ task: Task)
}

protocol ListInteractorOutputProtocool: AnyObject {
    func didFetchTasks(_ task: [Task])
    func didErrorFetchingTask(_ error: Error)
}


final class ListInteractor: ListInteractorProtocool {
    
    weak var presenter: ListInteractorOutputProtocool?
    weak var view: ListInteractorProtocool?
    
    func fetchTasks() {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "InitialDataLoaded") {
            let tasks = CoreDataManager.dataManager.fetchTasks()
            self.presenter?.didFetchTasks(tasks)
            return
        }
        APIService.shared.fetchTodo { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let tasks):
                CoreDataManager.dataManager.saveTasks(tasks)
                defaults.set(true, forKey: "InitialDataLoaded")
                self.presenter?.didFetchTasks(CoreDataManager.dataManager.fetchTasks())
            case .failure(let error):
                self.presenter?.didErrorFetchingTask(error)
            }
        }
    }
    
    func updateTask(_ task: Task) {
        CoreDataManager.dataManager.updateTask(task)
    }
}

