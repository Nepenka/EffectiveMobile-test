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
    func deleteTask(_ task: Task)
    func didTapAddTask()
    func didTapEditTask(_ task: Task)
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
    
    func deleteTask(_ task: Task) {
        interactor?.deleteTask(task)
    }
    
    func didTapAddTask() {
        router?.showDetail(with: nil)
    }
    
    func didTapEditTask(_ task: Task) {
        router?.showDetail(with: task)
    }
}


extension ListPresenter: ListInteractorOutputProtocool {
    func didFetchTasks(_ task: [Task]) {
        var allTask = task
        if let newTask = task.last {
            allTask.removeLast()
            allTask.insert(newTask, at: 0)
        }
        view?.showTask(allTask)
    }
    
    func didErrorFetchingTask(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
    
    
}
