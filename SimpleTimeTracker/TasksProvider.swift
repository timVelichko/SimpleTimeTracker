//
//  TasksProvider.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 27.02.2023.
//

import Foundation
import Combine

protocol TasksProvider {
    var tasksPublisher: AnyPublisher<[Task], Error> { get }
    var publisherForUpdates: AnyPublisher<[Task], Error> { get }
    func store(task: Task)
    func delete(task: Task)
}

class UserDefaultsTaskProvider: TasksProvider {
    
    enum UserDefaultsError: Error {
        case unknown
    }
    
    private let defaults = UserDefaults.standard
    private let tasksKey = "tasks"
    
    var tasksPublisher: AnyPublisher<[Task], Error> {
        guard let data = defaults.data(forKey: tasksKey),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return Fail(error: UserDefaultsError.unknown)
                .eraseToAnyPublisher()
        }
        
        return Just(tasks)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var publisherForUpdates: AnyPublisher<[Task], Error> {
        defaults.publisher(for: \.tasks)
            .compactMap { $0 }
            .tryMap { try JSONDecoder().decode([Task].self, from: $0) }
            .eraseToAnyPublisher()
    }
    
    func store(task: Task) {
        var storedTasks = storedTasksOrEmpty
        storedTasks.append(task)
        if let data = try? JSONEncoder().encode(storedTasks) {
            defaults.set(data, forKey: tasksKey)
        }
    }
    
    func delete(task: Task) {
        let storedTasks = storedTasksOrEmpty
        let filteredTasks = storedTasks.filter { $0.id != task.id }
        if storedTasks.count != filteredTasks.count,
           let data = try? JSONEncoder().encode(filteredTasks) {
            defaults.set(data, forKey: tasksKey)
        }
    }
    
}

extension UserDefaults {
    
    @objc dynamic var tasks: Data? {
        return data(forKey: "tasks")
    }
    
}

private extension UserDefaultsTaskProvider {
    
    var storedTasksOrEmpty: [Task] {
        if let data = defaults.data(forKey: tasksKey),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            return tasks
        }
        
        return []
    }
    
}
