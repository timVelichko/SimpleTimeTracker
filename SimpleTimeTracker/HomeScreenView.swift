//
//  HomeScreenView.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 26.02.2023.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State private var tasks: [Task] = [
        Task(name: "hello"),
        Task(name: "hello2")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            TrackerView()
            Spacer()
            TasksList(tasks: tasks)
            Spacer()
        }
    }
}

struct Task: Identifiable {
    let id = UUID()
    var name: String?
    let duration: TimeInterval = 0
    let dateStarted = Date()
}

struct TasksList: View {
    
    @State private var tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    var body: some View {
        List {
            ForEach(tasks, id: \.id) { task in
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

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
