//
//  TileSelection.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/28/21.
//

import SwiftUI

enum SelectionType {
    case userFocus
    case potentialMove
    case warning
    case lastMove
}

struct SelectTileView: View {
    
    let selectionType: SelectionType
    let theme: Theme
    
    var body: some View {
        Rectangle()
            .fill(theme.selectionColorGetter(selectionType).opacity(0.5))
    }
}

struct SelectTileViewModifier: ViewModifier {
    
    let selectionType: SelectionType
    let theme: Theme
    
    func body(content: Content) -> some View {
        content.overlay(Rectangle()
                            .strokeBorder(theme.selectionColorGetter(selectionType), lineWidth: theme.selectionBorderWidth)
                            .background(theme.selectionColorGetter(selectionType).opacity(0.25))
                            .transition(.scale))
    }
}

extension View {
    func selectView(selectionType: SelectionType?, theme: Theme) -> some View {
        if let type = selectionType {
            return AnyView(self.modifier(SelectTileViewModifier(selectionType: type, theme: theme)))
        } else {
            return AnyView(self)
        }
    }
}
