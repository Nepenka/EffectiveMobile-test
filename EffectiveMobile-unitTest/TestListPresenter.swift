//
//  TestListPresenter.swift
//  EffectiveMobile-unitTest
//
//  Created by Владислав Перелыгин on 02/10/2025.
//

import XCTest
@testable import EffectiveMobile_test

final class ListPresenterTests: XCTestCase {

    class MockView: ListViewProtocool {
        var showTaskCalled = false
        var showErrorCalled = false
        var tasksReceived: [Task]?
        var errorMessage: String?
        
        func showTask(_ task: [Task]) {
            showTaskCalled = true
            tasksReceived = task
        }
        
        func showError(_ message: String) {
            showErrorCalled = true
            errorMessage = message
        }
    }
    
    class MockInteractor: ListInteractorProtocool {
        var fetchTasksCalled = false
        var updateTaskCalledWith: Task?
        var deleteTaskCalledWith: Task?
        
        func fetchTasks() {
            fetchTasksCalled = true
        }
        
        func updateTask(_ task: Task) {
            updateTaskCalledWith = task
        }
        
        func deleteTask(_ task: Task) {
            deleteTaskCalledWith = task
        }
    }
    
    class MockRouter: ListRouterProtocool {
        var showDetailCalledWith: Task?
        
        static func start() -> UIViewController { return UIViewController() }
        
        func showDetail(with task: Task?) {
            showDetailCalledWith = task
        }
    }
    
    func testViewDidLoadCallsFetchTasks() {
        let presenter = ListPresenter()
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let mockRouter = MockRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "При viewDidLoad должен вызываться fetchTasks")
    }
    
    func testDidFetchTasksUpdatesView() {
        let presenter = ListPresenter()
        let mockView = MockView()
        presenter.view = mockView
        
        let tasks = [
            Task(id: 1, todo: "Test 1", description: nil, completed: false, date: Date(), userId: 0),
            Task(id: 2, todo: "Test 2", description: nil, completed: false, date: Date(), userId: 0)
        ]
        
        presenter.didFetchTasks(tasks)
        
        XCTAssertTrue(mockView.showTaskCalled, "View должна быть обновлена через showTask")
        XCTAssertEqual(mockView.tasksReceived?.first?.id, tasks.last?.id, "Новая задача должна быть вставлена на первое место")
    }
    
    func testDidErrorFetchingTaskCallsShowError() {
        let presenter = ListPresenter()
        let mockView = MockView()
        presenter.view = mockView
        
        let error = NSError(domain: "Test", code: 1)
        presenter.didErrorFetchingTask(error)
        
        XCTAssertTrue(mockView.showErrorCalled, "View должна показать ошибку")
        XCTAssertEqual(mockView.errorMessage, error.localizedDescription)
    }
    
    func testToggleTaskCallsInteractorUpdate() {
        let presenter = ListPresenter()
        let mockInteractor = MockInteractor()
        presenter.interactor = mockInteractor
        
        let task = Task(id: 1, todo: "Test", description: nil, completed: false, date: Date(), userId: 0)
        presenter.toggleTask(task)
        
        XCTAssertEqual(mockInteractor.updateTaskCalledWith?.id, task.id)
    }
    
    func testDeleteTaskCallsInteractorDelete() {
        let presenter = ListPresenter()
        let mockInteractor = MockInteractor()
        presenter.interactor = mockInteractor
        
        let task = Task(id: 1, todo: "Test", description: nil, completed: false, date: Date(), userId: 0)
        presenter.deleteTask(task)
        
        XCTAssertEqual(mockInteractor.deleteTaskCalledWith?.id, task.id)
    }
    
    func testDidTapAddTaskCallsRouter() {
        let presenter = ListPresenter()
        let mockRouter = MockRouter()
        presenter.router = mockRouter
        
        presenter.didTapAddTask()
        
        XCTAssertNil(mockRouter.showDetailCalledWith, "При добавлении новой задачи router.showDetail должен вызываться с nil")
    }
    
    func testDidTapEditTaskCallsRouter() {
        let presenter = ListPresenter()
        let mockRouter = MockRouter()
        presenter.router = mockRouter
        
        let task = Task(id: 1, todo: "Test", description: nil, completed: false, date: Date(), userId: 0)
        presenter.didTapEditTask(task)
        
        XCTAssertEqual(mockRouter.showDetailCalledWith?.id, task.id, "Router.showDetail должен вызываться с редактируемой задачей")
    }
}
