//
//  ContentView.swift
//  ToDoListApp
//
//  Created by George, Joshua on 4/16/24.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool = false
}

enum Sections: String, CaseIterable {
    case pending = "To Do"
    case completed = "Completed"
}

struct ContentView: View {
    
    @State private var tasks = [Task(name: "Finish all homework", isCompleted: false), Task(name: "Cook dinner"), Task(name: "Walk the dog")]
    
    var pendingTasks: [Binding<Task>] {
        $tasks.filter { !$0.isCompleted.wrappedValue }
    }
    
    var completedTasks: [Binding<Task>] {
        $tasks.filter { $0.isCompleted.wrappedValue }
    }
  
    
    var body: some View {
        List {
            ForEach(Sections.allCases, id: \.self) { section in
                Section {
                    
                    let filteredTasks = section == .pending ? pendingTasks: completedTasks
                    
                    if filteredTasks.isEmpty {
                        Text("No tasks available.")
                    }
                    
                    ForEach(filteredTasks) { $task in
                        TaskViewCell(task: $task)
                    }.onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            let taskToDelete = filteredTasks[index]
                            tasks = tasks.filter { $0.id != taskToDelete.id }
                        }
                    }
                    
                } header: {
                    Text(section.rawValue)
                } .bold()

            }
        }
    }
}

struct TaskViewCell: View {
    
    @Binding var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            Text(task.name).strikethrough(task.isCompleted)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
