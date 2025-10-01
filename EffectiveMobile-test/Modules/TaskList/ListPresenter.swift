//
//  ListPresenter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit


protocol ListPresenterProtocool: AnyObject {
    func viewDidLoad()
}

final class ListPresenter: ListPresenterProtocool {
    weak var view: ListViewProtocool?
    var interactor: ListInteractorProtocool?
    var router: ListRouterProtocool?
    
    func viewDidLoad() {
        interactor?.fetchTasks()
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
