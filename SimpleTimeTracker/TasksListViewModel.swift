//
//  TasksListViewModel.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 27.02.2023.
//

import Foundation
import Combine

struct Task: Identifiable, Codable {
    var id = UUID()
    var name: String?
    var dateStarted = Date()
    var dateFinished: Date?
}

class TasksListViewModel: ObservableObject {
    
    @Published private(set) var tasks = [Task]()
    
    private let provider: TasksProvider
    private var updatesSubscription: Cancellable?
    
    init(provider: TasksProvider = UserDefaultsTaskProvider()) {
        self.provider = provider
        
        updatesSubscription = provider.publisherForUpdates.sink(receiveCompletion: { _ in
            // handle error
        }, receiveValue: { [weak self] tasks in
            self?.tasks = tasks
        })
    }
    
}
