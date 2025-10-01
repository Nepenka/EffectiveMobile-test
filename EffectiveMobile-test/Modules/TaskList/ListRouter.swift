//
//  ListRouter.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//

import UIKit


protocol ListRouterProtocool: AnyObject {
    static func start() -> UIViewController
}

final class TaskRouter: ListRouterProtocool {
    
    
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
        
        
        return view
    }
}
