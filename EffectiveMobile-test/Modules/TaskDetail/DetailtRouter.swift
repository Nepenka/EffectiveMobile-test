//
//  DetailtRouter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import UIKit



protocol DetailRouterProtocol: AnyObject {
    func start(task: Task?) -> UIViewController
}

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
    
    func start(task: Task?) -> UIViewController {
        let vc = DetailViewController()
        let interactor = DetailInteractor(coreDataManager: CoreDataManager.dataManager)
        let presenter = DetailPresenter(view: vc, interactor: interactor, router: self, task: task)
        vc.presenter = presenter
        self.viewController = vc
        return vc
    }
}
