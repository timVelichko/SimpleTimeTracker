//
//  TasksListViewModelTests.swift
//  SimpleTimeTrackerTests
//
//  Created by Tim Vialichka on 27.02.2023.
//

import XCTest
import Combine
@testable import SimpleTimeTracker

fileprivate class MockTasksProvider: TasksProvider {
    
    var tasksPublisher: AnyPublisher<[Task], Error> = [].publisher
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    var publisherForUpdates: AnyPublisher<[Task], Error>
    
    func store(task: Task) {}
    
    var tasksDeleted = [Task]()
    func delete(task: Task) {
        tasksDeleted.append(task)
    }
    
    init() {
        var newTasks = [
            [Task(name: "1")],
            [Task(name: "1"), Task(name: "2")],
            [Task(name: "1"), Task(name: "2"), Task(name: "3")]
        ]
        publisherForUpdates = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .map { _ in newTasks.popLast()! }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    init(with staticTasks: [[Task]]) {
        publisherForUpdates = staticTasks
            .publisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

final class TasksListViewModelTests: XCTestCase {

    private var viewModel = TasksListViewModel()
    private var mockProvider = MockTasksProvider()
    
    override func setUpWithError() throws {
        mockProvider = MockTasksProvider()
        viewModel = TasksListViewModel(provider: mockProvider)
    }
    
    func testUpdatesSusbcription() {
        XCTAssertEqual(viewModel.tasks.count, 0)
        
        let queque = DispatchQueue(label: "secondary queue")
        let firstExp = expectation(description: "first wait")
        queque.asyncAfter(deadline: .now() + 1) {
            firstExp.fulfill()
        }
        wait(for: [firstExp], timeout: 1.1)
        XCTAssertEqual(viewModel.tasks.count, 3)
        XCTAssertEqual(viewModel.tasks[2].name, "3")
        
        let secondExp = expectation(description: "second wait")
        queque.asyncAfter(deadline: .now() + 1) {
            secondExp.fulfill()
        }
        wait(for: [secondExp], timeout: 1.1)
        XCTAssertEqual(viewModel.tasks.count, 2)
        XCTAssertEqual(viewModel.tasks[1].name, "2")

        let thirdExp = expectation(description: "third wait")
        queque.asyncAfter(deadline: .now() + 1) {
            thirdExp.fulfill()
        }
        wait(for: [thirdExp], timeout: 1.1)
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks[0].name, "1")
    }
    
    func testDeleteTasks() {
        let tasks = [Task(name: "1"), Task(name: "2"), Task(name: "3")]
        mockProvider = MockTasksProvider(with: [tasks])
        viewModel = TasksListViewModel(provider: mockProvider)
        
        var indexSet = IndexSet([1,2])
        viewModel.deleteTasks(with: indexSet)
        XCTAssertEqual(mockProvider.tasksDeleted.count, 2)
        XCTAssertEqual(mockProvider.tasksDeleted.first?.name, "2")
        XCTAssertEqual(mockProvider.tasksDeleted.last?.name, "3")
    }

}
