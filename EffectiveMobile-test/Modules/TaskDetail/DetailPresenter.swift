//
//  DetailPresenter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(title: String, description: String)
}

final class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol
    var router: DetailRouterProtocol
    private var task: Task?
    
    init(view: DetailViewProtocol,
         interactor: DetailInteractorProtocol,
         router: DetailRouterProtocol,
         task: Task?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.task = task
    }
    
    func viewDidLoad() {
        if let task = task {
            view?.showTask(task)
        } else {
            let newTask = Task(id: -1, todo: "",description: "" ,completed: false,date: Date() ,userId: 0)
            view?.showTask(newTask)
        }
    }
    
    func saveTask(title: String, description: String) {
        let currentData = Date()
        let finalTitle = title.isEmpty ? "Добавьте название задаче" : title
        let finalDescription = description.isEmpty ? "Добавьте описание задаче" : description
        if var task = task {
            task.todo = finalTitle
            task.description = finalDescription
            task.date = currentData
            interactor.updateTask(task)
        } else {
            interactor.createTask(title: finalTitle, description: finalDescription, date: currentData)
        }
    }
}
