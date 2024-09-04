//
//  MainViewModel.swift
//  TodoTodo
//
//  Created by 김주희 on 8/20/24.
//

import Foundation
import UIKit

class MainViewModel: ObservableObject {
    
    @Published var todoItems: [TodoItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    init() {
        loadItems()
    }
    
    // Group items by month and year
    var groupedItems: [String: [TodoItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        
        return Dictionary(grouping: todoItems) { (item: TodoItem) -> String in
            return formatter.string(from: item.dueDate)
        }
    }
    
    // Save items to UserDefaults
    private func saveItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todoItems) {
            UserDefaults.standard.set(encoded, forKey: "todoItems")
        }
    }
    
    // Load items from UserDefaults
    private func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "todoItems") {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([TodoItem].self, from: savedItems) {
                todoItems = decodedItems
            }
        }
    }
    
    // Add a new TodoItem
    func addTodoItem(title: String, dueDate: Date, image: UIImage?) {
        let newItem = TodoItem(title: title, dueDate: dueDate, image: image)
        todoItems.append(newItem)
    }
    
    // Remove a TodoItem
    func removeTodoItem(item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
    }
}
