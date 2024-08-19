//
//  Extension+View.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(hidden: Bool = false, remove: Bool = false) -> some View {
        modifier(IsHidden(hidden: hidden, remove: remove))
    }
}

struct IsHidden: ViewModifier {
    var hidden = false
    var remove = false
    func body(content: Content) -> some View {
        if hidden {
            if remove {
                
            } else {
                content.hidden()
            }
        } else {
            content
        }
    }
}

extension View {

    @ViewBuilder func toast(message: String, isShowing: Binding<Bool>, duration: TimeInterval) -> some View {

      self.modifier(Toast(message: message, isShowing: isShowing, config: .init(duration: duration)))

    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
