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
    
    var body: some View {
        List {
            ForEach(viewModel.groupedItems.keys.sorted(), id: \.self) { date in
                Section(header: Text("\(date, formatter: dateFormatter)")
                            .font(.headline)
                            .foregroundColor(.orange)) {
                    ForEach(viewModel.groupedItems[date] ?? []) { item in
                        TodoCell(title: item.title, date: item.timeRemaining, image: item.image)
                    }
                }
            }
            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        }
        .listStyle(InsetGroupedListStyle())
        .frame(maxHeight: 350)
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
}

struct TodoCell: View {
    
    var title: String
    var date: String
    var image: UIImage?
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                if let image = image {
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
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.orange)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
