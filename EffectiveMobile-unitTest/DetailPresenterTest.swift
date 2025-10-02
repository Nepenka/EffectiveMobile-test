//
//  DetailPresenterTest.swift
//  EffectiveMobile-unitTest
//
//  Created by Владислав Перелыгин on 02/10/2025.
//


import XCTest
@testable import EffectiveMobile_test

final class DetailPresenterTests: XCTestCase {

    class MockDetailInteractor: DetailInteractorProtocol {
        var createdTask: Task?
        var updatedTask: Task?
        
        func createTask(title: String, description: String, date: Date) {
            createdTask = Task(id: 9999, todo: title, description: description, completed: false, date: date, userId: 0)
        }
        
        func updateTask(_ task: Task) {
            updatedTask = task
        }
    }
    
    class MockView: DetailViewProtocol {
        var displayedTask: Task?
        func showTask(_ task: Task) {
            displayedTask = task
        }
    }
    
    func testSaveNewTaskCallsCreateTask() {
        let mockInteractor = MockDetailInteractor()
        let mockView = MockView()
        let router = DetailRouter()
        let presenter = DetailPresenter(view: mockView, interactor: mockInteractor, router: router, task: nil)
        
        presenter.saveTask(title: "Test Title", description: "Test Desc")
        
        XCTAssertNotNil(mockInteractor.createdTask)
        XCTAssertEqual(mockInteractor.createdTask?.todo, "Test Title")
        XCTAssertEqual(mockInteractor.createdTask?.description, "Test Desc")
    }
    
    func testSaveExistingTaskCallsUpdateTask() {
        let mockInteractor = MockDetailInteractor()
        let mockView = MockView()
        let router = DetailRouter()
        let existingTask = Task(id: 1, todo: "Old", description: "Old Desc", completed: false, date: Date(), userId: 0)
        let presenter = DetailPresenter(view: mockView, interactor: mockInteractor, router: router, task: existingTask)
        
        presenter.saveTask(title: "Updated Title", description: "Updated Desc")
        
        XCTAssertNotNil(mockInteractor.updatedTask)
        XCTAssertEqual(mockInteractor.updatedTask?.todo, "Updated Title")
        XCTAssertEqual(mockInteractor.updatedTask?.description, "Updated Desc")
        XCTAssertNotEqual(mockInteractor.updatedTask?.date, existingTask.date) 
    }
    
    func testEmptyFieldsUseDefaultValues() {
        let mockInteractor = MockDetailInteractor()
        let mockView = MockView()
        let router = DetailRouter()
        let presenter = DetailPresenter(view: mockView, interactor: mockInteractor, router: router, task: nil)
        
        presenter.saveTask(title: "", description: "")
        
        XCTAssertEqual(mockInteractor.createdTask?.todo, "Добавьте название задаче")
        XCTAssertEqual(mockInteractor.createdTask?.description, "Добавьте описание задаче")
    }
}
