//
//  TrackerViewModel.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 27.02.2023.
//

import Foundation
import Combine

class TrackerViewModel: ObservableObject {
    
    @Published private(set) var isTracking = false
    @Published private(set) var buttonTitle = "homeScreen.start"
    @Published private(set) var timerTitle = "0:00:00"
    @Published var taskTitle = "" {
        didSet { currentTask?.name = taskTitle }
    }
    
    private var timer: Timer?
    private var secondsCount: TimeInterval = 0 {
        didSet { timerTitle = String(secondsCount) }
    }
    private var currentTask: Task?
    private let tasksProvider: TasksProvider
    
    init(tasksProvider: TasksProvider = UserDefaultsTaskProvider()) {
        self.tasksProvider = tasksProvider
    }
    
    func trackerButtonTapped() {
        isTracking.toggle()
        buttonTitle = isTracking ? "homeScreen.stop" : "homeScreen.start"
        
        if isTracking {
            currentTask = Task()
            let aTimer = Timer(timeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self else { return }
                self.secondsCount += 1
            })
            RunLoop.current.add(aTimer, forMode: .common)
            timer = aTimer
        } else {
            timer?.invalidate()
            timer = nil
            
            if var currentTask {
                currentTask.dateFinished = Date()
                tasksProvider.store(task: currentTask)
            }
            taskTitle = ""
            secondsCount = 0
            currentTask = nil
        }
    }
    
    func titleSubmited() {
        if isTracking == false {
            trackerButtonTapped()
        }
    }
    
    func recalculateTimer() {
        guard let currentTask else { return }
        secondsCount = -currentTask.dateStarted.timeIntervalSinceNow
    }
    
}
