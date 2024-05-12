//
//  MainView.swift
//  TodoTodo
//
//  Created by 김주희 on 5/12/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader {_ in
            VStack {
                TitleView()
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            Text("TodoTodo")
                .font(.system(size: 20).weight(.bold))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 0))
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 30))
                    .foregroundColor(.orange)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
            })
            
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

#Preview {
    MainView()
}
