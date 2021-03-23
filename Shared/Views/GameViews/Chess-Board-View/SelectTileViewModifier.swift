//
//  TileSelection.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/28/21.
//

import SwiftUI

struct SelectTileView: View {
    
    let selectionType: ChessGame.SelectionType
    let theme: Theme
    
    var body: some View {
        Rectangle()
//            .strokeBorder(theme.selectionColorGetter(selectionType), lineWidth: theme.selectionBorderWidth)
            .fill(theme.selectionColorGetter(selectionType).opacity(0.5))
//            .transition(.scale)
    }
}

struct SelectTileViewModifier: ViewModifier {
    
    let selectionType: ChessGame.SelectionType
    let theme: Theme
    
    func body(content: Content) -> some View {
        content.overlay(Rectangle()
                            .strokeBorder(theme.selectionColorGetter(selectionType), lineWidth: theme.selectionBorderWidth)
                            .background(theme.selectionColorGetter(selectionType).opacity(0.25))
                            .transition(.scale)
        
        )
    }
}

extension View {
    func selectView(selectionType: ChessGame.SelectionType?, theme: Theme) -> some View {
        if let type = selectionType {
            return AnyView(self.modifier(SelectTileViewModifier(selectionType: type, theme: theme)))
        } else {
            return AnyView(self)
        }
    }
}
