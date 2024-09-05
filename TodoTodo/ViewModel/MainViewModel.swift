//
//  MainViewModel.swift
//  TodoTodo
//
//  Created by 김주희 on 8/20/24.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = [] {
        didSet {
            saveTodoItems()
        }
    }
    
    private let todoItemsKey = "todoItemsKey"

    init() {
        loadTodoItems()
    }
    
    var groupedItems: [String: [TodoItem]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        
        return Dictionary(grouping: todoItems) { (item: TodoItem) -> String in
            return formatter.string(from: item.dueDate)
        }
    }
    
    // TodoItem을 UserDefaults에 저장
    func saveTodoItems() {
        do {
            let encodedData = try JSONEncoder().encode(todoItems)
            UserDefaults.standard.set(encodedData, forKey: todoItemsKey)
            print("Todo items saved successfully.")
        } catch {
            print("Failed to encode todo items: \(error)")
        }
    }

    // UserDefaults에서 TodoItem 불러오기
    private func loadTodoItems() {
        guard let savedData = UserDefaults.standard.data(forKey: todoItemsKey) else {
            print("No saved data found.")
            return
        }
        
        do {
            let decodedItems = try JSONDecoder().decode([TodoItem].self, from: savedData)
            self.todoItems = decodedItems
            print("Todo items loaded successfully.")
        } catch {
            print("Failed to decode todo items: \(error)")
        }
    }

    // TodoItem 추가
    func addTodoItem(_ item: TodoItem) {
        todoItems.append(item)
    }

    // TodoItem 삭제
    func removeTodoItem(item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
    }
    
    // TodoItem 업데이트
    func updateTodoItem(_ updatedItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == updatedItem.id }) {
            todoItems[index] = updatedItem
        }
    }
}
