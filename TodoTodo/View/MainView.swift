//
//  MainView.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TitleView(viewModel: viewModel)
            TodoListView(viewModel: viewModel)
            CalendarView()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TitleView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State var showAddTodoView: Bool = false
    
    var body: some View {
        HStack {
            Text("TodoTodo")
                .font(.system(size: 24).weight(.bold))
                .padding(.leading, 15)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    showAddTodoView.toggle()
                }, label: {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                })
                .sheet(isPresented: $showAddTodoView) {
                    AddTodoView(viewModel: viewModel)
                }
                
                Button(action: {
                    // Action for profile button
                }, label: {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                })
            }
            .padding(.trailing, 15)
        }
        .padding(.vertical, 15)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 M월"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
}()

struct TodoListView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var showDeleteAlert = false
    @State private var selectedItem: TodoItem? = nil
    
    var body: some View {
        List {
            ForEach(viewModel.groupedItems.keys.sorted(by: >), id: \.self) { month in
                Section(header: Text(month)
                    .font(.headline)
                    .foregroundColor(.orange)) {
                    ForEach(viewModel.groupedItems[month] ?? []) { item in
                        TodoCell(selectedItem: $selectedItem, showDeleteAlert: $showDeleteAlert, item: item)
                    }
                }
            }
            .listRowInsets(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(InsetGroupedListStyle())
        .frame(maxHeight: 350)
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("일정 삭제"),
                message: Text("해당 일정을 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("예")) {
                    if let selectedItem = selectedItem {
                        viewModel.removeTodoItem(item: selectedItem)
                    }
                },
                secondaryButton: .cancel(Text("아니요"))
            )
        }
        .sheet(item: $selectedItem) { todo in
            AddTodoView(viewModel: viewModel, todoItem: todo)
        }
    }
}

struct TodoCell: View {
    
    @Binding var selectedItem: TodoItem?
    @Binding var showDeleteAlert: Bool
    @State private var isPressed: Bool = false
    let item: TodoItem
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                if let image = item.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(item.timeRemaining)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(isPressed ? Color.orange : Color.orange.opacity(0.5))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            selectedItem = item
        }
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { isPressing in
                withAnimation {
                    isPressed = isPressing
                }
            },
            perform: {
                selectedItem = item
                showDeleteAlert.toggle()
            }
        )
    }
}

struct CalendarView: View {
    
    @State var date = Date()
    
    var body: some View {
        DatePicker(
            "날짜",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(GraphicalDatePickerStyle())
        .environment(\.locale, Locale(identifier: "ko_KR"))
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
}

#Preview {
    MainView()
}
