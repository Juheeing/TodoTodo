//
//  BottomNaviView.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import SwiftUI

struct BottomNaviView: View {
    var body: some View {
        VStack {
            MenuView()
        }
    }
}

struct MenuView: View {
    
    @State var selection: Int = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            MainView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    selection == 0 ? Image(systemName: "house.fill") : Image(systemName: "house.fill")
                }
                .tag(0)
            MyPageView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    selection == 1 ? Image(systemName: "list.dash") : Image(systemName: "list.dash")
                }
                .tag(1)
        }
        .accentColor(.orange)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.white)
            UITabBar.appearance().barTintColor = UIColor(Color.gray)
        }
    }
}


#Preview {
    BottomNaviView()
}
