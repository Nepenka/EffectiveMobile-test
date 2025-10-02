//
//  TestListInteractor.swift
//  EffectiveMobile-unitTest
//
//  Created by Владислав Перелыгин on 02/10/2025.
//

import XCTest
@testable import EffectiveMobile_test

final class ListInteractorTests: XCTestCase {
    
    class MockPresenter: ListInteractorOutputProtocool {
        var fetchedTasks: [Task]?
        var errorMessage: String?
        
        func didFetchTasks(_ task: [Task]) {
            fetchedTasks = task
        }
        
        func didErrorFetchingTask(_ error: Error) {
            errorMessage = error.localizedDescription
        }
    }
    
    func testFetchTasksReturnsTasks() {
        let interactor = ListInteractor()
        let mockPresenter = MockPresenter()
        interactor.presenter = mockPresenter
        
        interactor.fetchTasks()
        
        XCTAssertNotNil(mockPresenter.fetchedTasks)
    }
    
    func testDeleteTaskRemovesTask() {
        let interactor = ListInteractor()
        let mockPresenter = MockPresenter()
        interactor.presenter = mockPresenter
        
        let task = Task(id: 1, todo: "Test", description: "Desc", completed: false, date: Date(), userId: 0)
        CoreDataManager.dataManager.saveTasks([task])
        
        interactor.deleteTask(task)
        
        let tasks = CoreDataManager.dataManager.fetchTasks()
        XCTAssertFalse(tasks.contains { $0.id == task.id })
    }
}
