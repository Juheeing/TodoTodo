//
//  MainViewModel.swift
//  TodoTodo
//
//  Created by 김주희 on 8/20/24.
//

import Foundation
import UIKit

class MainViewModel: ObservableObject {
    
    @Published var todoItems: [TodoItem] = []
    
    var groupedItems: [Date: [TodoItem]] {
        Dictionary(grouping: todoItems) { (item: TodoItem) -> Date in
            let calendar = Calendar.current
            return calendar.startOfDay(for: item.dueDate)
        }
    }
    
    init() {
        todoItems = [
            TodoItem(title: "쇼핑", dueDate: Date().addingTimeInterval(3600), image: UIImage(systemName: "cart")),
            TodoItem(title: "프로젝트", dueDate: Date().addingTimeInterval(7200), image: nil),
            TodoItem(title: "전화미팅", dueDate: Date().addingTimeInterval(108000), image: UIImage(systemName: "phone"))
        ]
    }
}
