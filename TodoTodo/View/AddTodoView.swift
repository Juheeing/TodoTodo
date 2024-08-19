//
//  AddTodoView.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView() {
            VStack {
                TodoImageView()
                TodoContentView()
            }
            .navigationBarItems(leading: Button("취소", action: {presentationMode.wrappedValue.dismiss()}).foregroundColor(.red), trailing: Button("추가", action: { }).foregroundColor(.orange))
        }
    }
}

struct TodoImageView: View {
    var body: some View {
        VStack{
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 100))
                .frame(width: UIScreen.main.bounds.width)
                .foregroundColor(.white)
                .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

struct TodoContentView: View {
    
    @State var title = ""
    @State var memo = ""
    @State var date = Date()
    @State var pushOn = false
    
    var body: some View {
        VStack {
            TextField("제목", text: $title)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
            
            DatePicker(
                "날짜",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .padding()
            
            DatePicker("시간", selection: $date,
                               displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .padding()
            
            Toggle("푸시", isOn: $pushOn)
                .padding()
            
            TextField("메모", text: $memo)
                .padding()
                .frame(height: 200)
                .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}

#Preview {
    AddTodoView()
}
