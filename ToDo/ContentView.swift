//
//  ContentView.swift
//  To Do
//
//  Created by Bitmorpher 4 on 4/29/21.
//

import SwiftUI
import CoreData

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    let todo: String
}

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos: [TodoItem] = []
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add todo", text: $newTodo).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !self.newTodo.isEmpty else { return }
                        self.allTodos.append(TodoItem(todo: newTodo))
                        self.newTodo = ""
                        saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 5)
                }.padding()
                
                List {
                    ForEach(allTodos) { todoItem in
                        
                        NavigationLink(destination: TaskView()) {
                            Text(todoItem.todo)
                        }
                    }.onDelete(perform: deleteTodo(at:))
                }
            }
            .navigationBarTitle("ToDo Siam Project")
        }.onAppear(perform: loadTodos)
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: "todosKey")
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: "todosKey") as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
}

