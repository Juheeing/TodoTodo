//
//  Toast.swift
//  TodoTodo
//
//  Created by 김주희 on 8/19/24.
//

import Foundation
import SwiftUI

struct Toast: ViewModifier {

  static let short: TimeInterval = 2
  static let long: TimeInterval = 3.5
  let message: String
  @Binding var isShowing: Bool
  let config: Config

  func body(content: Content) -> some View {

    ZStack {
      content
      toastView
    }
  }

  private var toastView: some View {

    VStack {
        
      Spacer()

      if isShowing {
        Group {
          Text(message)
            .multilineTextAlignment(.center)
            .foregroundColor(config.textColor)
            .font(config.font)
            .padding(.vertical, 16)
            .padding(.horizontal, 30)
        }
        .background(Capsule().foregroundColor(config.backgroundColor))
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            isShowing = false
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 18)
    .animation(config.animation, value: isShowing)
    .transition(config.transition)
  }

  struct Config {

    let textColor: Color
    let font: Font
    let backgroundColor: Color
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation

    init(textColor: Color = .white,
         font: Font = .system(size: 12),
         backgroundColor: Color = .black.opacity(0.588),
         duration: TimeInterval = Toast.short,
         transition: AnyTransition = .opacity,
         animation: Animation = .linear(duration: 0.3)) {

      self.textColor = textColor
      self.font = font
      self.backgroundColor = backgroundColor
      self.duration = duration
      self.transition = transition
      self.animation = animation

    }
  }
}

