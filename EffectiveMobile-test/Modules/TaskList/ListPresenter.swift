//
//  ListPresenter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit


protocol ListPresenterProtocool: AnyObject {
    func viewDidLoad()
    func toggleTask(_ task: Task)
}

final class ListPresenter: ListPresenterProtocool {
    weak var view: ListViewProtocool?
    var interactor: ListInteractorProtocool?
    var router: ListRouterProtocool?
    
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func toggleTask(_ task: Task) {
        interactor?.updateTask(task)
    }
}


extension ListPresenter: ListInteractorOutputProtocool {
    func didFetchTasks(_ task: [Task]) {
        view?.showTask(task)
    }
    
    func didErrorFetchingTask(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
    
    
}
