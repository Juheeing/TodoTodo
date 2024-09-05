//
//  ImageStorageManager.swift
//  TodoTodo
//
//  Created by 김주희 on 2024/09/06.
//

import Foundation
import UIKit

class ImageStorageManager {
    
    func saveImageToFileSystem(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: filePath)
            return fileName
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func loadImageFromFileSystem(fileName: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: filePath.path)
    }
}
