//
//  ListRouter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//

import UIKit


protocol ListRouterProtocool: AnyObject {
    static func start() -> UIViewController
    func showDetail(with task: Task?)
}

final class TaskRouter: ListRouterProtocool {
    weak var viewController: UIViewController?
    
    static func start() -> UIViewController {
        let view = ListViewController()
        let presenter = ListPresenter()
        let interactor = ListInteractor()
        let router = TaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func showDetail(with task: Task?) {
        let detailVC = DetailRouter().start(task: task)
        
        if let detailVC = detailVC as? DetailViewController {
            detailVC.onSave = { [weak self] in
                if let listVC = self?.viewController as? ListViewController {
                    listVC.presenter?.viewDidLoad()
                }
            }
        }
        
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
