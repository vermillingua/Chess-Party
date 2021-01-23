//
//  MenuButtonModifier.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .frame(maxWidth: 400, maxHeight: 50)
            .background(configuration.isPressed ? Color.yellow : Color.green)
            .cornerRadius(8)
            .padding(.horizontal)
            .font(.title)
    }
    
}

extension Button {
    func menuButtonify() -> some View {
        self.buttonStyle(MenuButtonStyle())
    }
}
