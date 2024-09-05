//
//  AddTodoView.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import SwiftUI
import UIKit

struct AddTodoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MainViewModel
    var todoItem: TodoItem? = nil
    
    @State private var title: String = ""
    @State private var memo: String = ""
    @State private var date: Date = Date()
    @State private var pushOn: Bool = false
    @State private var image: UIImage? = nil
    private let imageStorageManager = ImageStorageManager()
    
    init(viewModel: MainViewModel, todoItem: TodoItem? = nil) {
        self.viewModel = viewModel
        self.todoItem = todoItem
        if let todoItem = todoItem {
            _title = State(initialValue: todoItem.title)
            _memo = State(initialValue: todoItem.memo ?? "")
            _date = State(initialValue: todoItem.dueDate)
            _pushOn = State(initialValue: todoItem.push)
            _image = State(initialValue: imageStorageManager.loadImageFromFileSystem(fileName: todoItem.imageFileName ?? ""))
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TodoImageView(image: $image)
                        .frame(height: 200)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    TodoContentView(title: $title, memo: $memo, date: $date, pushOn: $pushOn)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .navigationBarTitle(todoItem == nil ? "할 일 추가" : "할 일 수정", displayMode: .inline)
            .navigationBarItems(
                leading: Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red),
                trailing: Button(todoItem == nil ? "추가" : "수정") {
                    if todoItem != nil {
                        updateTodo()
                    } else {
                        addTodo()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.orange)
            )
        }
    }
    
    private func addTodo() {
        let fileName = image.flatMap { imageStorageManager.saveImageToFileSystem(image: $0) }
        let newTodo = TodoItem(title: title, dueDate: date, imageFileName: fileName, push: pushOn, memo: memo)
        viewModel.addTodoItem(newTodo)
    }
    
    private func updateTodo() {
        print("updateTodo called")
        if let index = viewModel.todoItems.firstIndex(where: { $0.id == todoItem?.id }) {
            var updatedItem = viewModel.todoItems[index]
            updatedItem.title = title
            updatedItem.memo = memo
            updatedItem.dueDate = date
            updatedItem.push = pushOn
            updatedItem.updateImage(newImage: image)
            
            viewModel.updateTodoItem(updatedItem)
            print("Item updated")
        }
    }
}

struct TodoImageView: View {
    @Binding var image: UIImage?
    @State private var showImagePicker = false
    @State private var selectImage = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                    
                    Text("Tap to select an image")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .onTapGesture {
            showImagePicker = true
        }
        .actionSheet(isPresented: $showImagePicker) {
            ActionSheet(title: Text("사진 선택"), message: nil, buttons: [
                .default(Text("카메라")) {
                    imagePickerSourceType = .camera
                    selectImage = true
                },
                .default(Text("앨범")) {
                    imagePickerSourceType = .photoLibrary
                    selectImage = true
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $selectImage) {
            ImagePicker(image: $image, sourceType: imagePickerSourceType)
        }
    }
}

struct TodoContentView: View {
    
    @Binding var title: String
    @Binding var memo: String
    @Binding var date: Date
    @Binding var pushOn: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("제목", text: $title)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            DatePicker(
                "날짜",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            DatePicker("시간", selection: $date, displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            Toggle("푸시", isOn: $pushOn)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            TextField("메모", text: $memo)
                .padding()
                .frame(height: 100)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


#Preview {
    AddTodoView(viewModel: MainViewModel())
}
