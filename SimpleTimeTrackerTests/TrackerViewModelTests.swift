//
//  TrackerViewModelTests.swift
//  SimpleTimeTrackerTests
//
//  Created by Tim Vialichka on 27.02.2023.
//

import XCTest
import Combine
@testable import SimpleTimeTracker

fileprivate class MockTasksProvider: TasksProvider {
    
    var tasksPublisher: AnyPublisher<[Task], Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var publisherForUpdates: AnyPublisher<[Task], Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var taskIsStored = false
    var taskHasDateFinished = false
    var taskHasName = false
    func store(task: Task) {
        taskIsStored = true
        if task.dateFinished != nil {
            taskHasDateFinished = true
        }
        if task.name?.count ?? 0 > 0 {
            taskHasName = true
        }
    }
    
    func delete(task: Task) {}
    
}

final class TrackerViewModelTests: XCTestCase {

    private var viewModel = TrackerViewModel()
    private var mockProvider = MockTasksProvider()
    
    override func setUpWithError() throws {
        mockProvider = MockTasksProvider()
        viewModel = TrackerViewModel(tasksProvider: mockProvider)
    }
    
    func testDefaultValues() {
        XCTAssertFalse(viewModel.isTracking)
        XCTAssertEqual(viewModel.buttonTitle, "homeScreen.start")
        XCTAssertEqual(viewModel.timerTitle, "0:00:00")
        XCTAssertEqual(viewModel.taskTitle, "")
    }
    
    func testTrackerButtonTapped() {
        viewModel.taskTitle = "test"
        viewModel.trackerButtonTapped()
        XCTAssertTrue(viewModel.isTracking)
        XCTAssertEqual(viewModel.buttonTitle, "homeScreen.stop")
        XCTAssertEqual(viewModel.taskTitle, "test", "Starting timer shouldn't affect task's name")
        XCTAssertFalse(mockProvider.taskIsStored)
        
        let expectation = expectation(description: "wait for timer")
        DispatchQueue(label: "secondary queue").asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.5)
        XCTAssertEqual(viewModel.timerTitle, "0:00:03", "Number of seconds should be updated in timer")
        
        viewModel.trackerButtonTapped()
        XCTAssertFalse(viewModel.isTracking)
        XCTAssertEqual(viewModel.buttonTitle, "homeScreen.start")
        XCTAssertEqual(viewModel.timerTitle, "0:00:00")
        XCTAssertEqual(viewModel.taskTitle, "")
        XCTAssertTrue(mockProvider.taskIsStored)
        XCTAssertTrue(mockProvider.taskHasDateFinished)
        XCTAssertTrue(mockProvider.taskHasName)
    }
    
    func testTitleSubmited() {
        viewModel.trackerButtonTapped() // switch isTracking flag on
        viewModel.titleSubmited()
        XCTAssertTrue(viewModel.isTracking, "Changing the title shouldn't affect when timer is running")
        
        viewModel.trackerButtonTapped() // switch isTracking flag off
        viewModel.titleSubmited()
        XCTAssertTrue(viewModel.isTracking, "Changing the title should turn on the timer")
    }
    
    func testRecalculateTimer() {
        viewModel.recalculateTimer()
        XCTAssertEqual(viewModel.timerTitle, "0:00:00", "No effect without current task")
        
        viewModel.trackerButtonTapped() // currentTask is now assigned
        let expectation = expectation(description: "wait for timer")
        DispatchQueue(label: "secondary queue").asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.5)
        
        viewModel.recalculateTimer()
        XCTAssertEqual(viewModel.timerTitle, "0:00:03", "Number of seconds should be updated in timer")
    }

}
