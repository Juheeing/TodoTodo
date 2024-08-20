//
//  MainView.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader {_ in
            VStack(spacing: 0) {
                TitleView()
                TodoListView()
                CalendarView()
            }
        }
    }
}

struct TitleView: View {
    
    @State var showAddTodoView: Bool = false
    
    var body: some View {
        HStack {
            Text("TodoTodo")
                .font(.system(size: 20).weight(.bold))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 0))
            
            Spacer()
            
            Button(action: {
                showAddTodoView.toggle()
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 30))
                    .foregroundColor(.orange)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
            })
            .sheet(isPresented: $showAddTodoView) {
                            AddTodoView()
            }
            
            Button(action: {
                
            }, label: {
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 15))
            })
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct TodoListView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        
        List {
            ForEach(viewModel.groupedItems.keys.sorted(), id: \.self) { date in
                Section(header: Text("\(date, formatter: dateFormatter)")) {
                    ForEach(viewModel.groupedItems[date] ?? []) { item in
                        TodoCell(title: item.title, date: item.timeRemaining, image: item.image)
                    }
                }
            }
            .listRowInsets(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(GroupedListStyle())
        .frame(height: 300)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct TodoCell: View {
    
    var title: String
    var date: String
    var image: UIImage?
    
    var body: some View {
        HStack {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .frame(width: 100, height: 50)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Divider().opacity(0)
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .lineLimit(1)
                
                Text(date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 100, alignment: .center)
        .background(Color.orange)
        .cornerRadius(15)
    }
}

struct CalendarView: View {
    
    @State var date = Date()
    
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

#Preview {
    MainView()
}
