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
                        Text(todoItem.todo)
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

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
