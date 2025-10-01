//
//  ListInteractor.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit


protocol ListInteractorProtocool: AnyObject {
    func fetchTasks()
}

protocol ListInteractorOutputProtocool: AnyObject {
    func didFetchTasks(_ task: [Task])
    func didErrorFetchingTask(_ error: Error)
}


final class ListInteractor: ListInteractorProtocool {
    weak var presenter: ListInteractorOutputProtocool?
    weak var view: ListInteractorProtocool?
    
    func fetchTasks() {
        APIService.shared.fetchTodo { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let tasks):
                self.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self.presenter?.didErrorFetchingTask(error)
            }
        }
    }
}

