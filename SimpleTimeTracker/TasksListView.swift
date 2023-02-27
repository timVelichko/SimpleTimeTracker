//
//  TasksListView.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 27.02.2023.
//

import SwiftUI

struct TasksListView: View {
    
    init(viewModel: TasksListViewModel = TasksListViewModel()) {
        self.viewModel = viewModel
    }
    
    @ObservedObject private var viewModel: TasksListViewModel
    
    var body: some View {
        let tasks = viewModel.tasks
        
        if tasks.count == 0 {
            Text("tasksScreen.listPlaceholder")
        } else {
            List {
                ForEach(viewModel.tasks, id: \.id) { task in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(task.name ?? "")
                            Spacer()
                            Text(String(task.dateStarted.formatted(date: .numeric, time: .omitted)))
                                .foregroundColor(.secondary)
                        }
                        Text(String(task.duration))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
                .onDelete { indexSet in
                    print(indexSet)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
    
}

extension Task {
    
    var duration: TimeInterval {
        guard let dateFinished else { return 0 }
        return dateFinished.timeIntervalSinceNow - dateStarted.timeIntervalSinceNow
    }
    
}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView()
    }
}
