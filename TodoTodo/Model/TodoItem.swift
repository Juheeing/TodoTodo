//
//  TodoItem.swift
//  TodoTodo
//
//  Created by 김주희 on 8/20/24.
//

import Foundation
import UIKit

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    let title: String  // 일정 제목
    let dueDate: Date  // 일정 날짜
    let imageData: Data?  // 이미지 (옵션)
    
    init(title: String, dueDate: Date, image: UIImage? = nil) {
        self.id = UUID()
        self.title = title
        self.dueDate = dueDate
        self.imageData = image?.jpegData(compressionQuality: 1.0)
    }
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // 일정까지 남은 시간을 계산하는 프로퍼티
    var timeRemaining: String {
        let now = Date()
        let interval = dueDate.timeIntervalSince(now)
        
        if interval <= 0 {
            return "일정이 종료되었습니다."
        } else {
            let days = Int(interval) / 86400
            let hours = (Int(interval) % 86400) / 3600
            let minutes = (Int(interval) % 3600) / 60
            
            var timeComponents: [String] = []
            
            if days > 0 {
                timeComponents.append("\(days)일")
            }
            if hours > 0 {
                timeComponents.append("\(hours)시간")
            }
            if minutes > 0 {
                timeComponents.append("\(minutes)분")
            }
            return "일정까지 " + timeComponents.joined(separator: " ") + " 남았습니다."
        }
    }
}
