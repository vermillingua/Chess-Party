//
//  Theme-D.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct ThemeD: Theme {
    let name: String = "Theme D"
    let primaryBoardColor: Color = Color.black
    let secondaryBoardColor: Color = Color.gray
    
    func getImageFor(piece: Piece) -> Image {
        let playerID = piece.player.id
        switch piece.type {
        case .bishop: return Image("Theme-D-\(playerID)-Bishop")
        case .knight: return Image("Theme-D-\(playerID)-Knight")
        case .rook: return Image("Theme-D-\(playerID)-Rook")
        case .pawn: return Image("Theme-D-\(playerID)-Pawn")
        case .queen: return Image("Theme-D-\(playerID)-Queen")
        case .king: return Image("Theme-D-\(playerID)-King")
        }
    }
    
    func colorForSelection(ofType selectionType: SelectionType) -> Color {
        switch selectionType {
        case .userFocus: return Color.yellow
        default: return Color.gray
        }
    }
    
    var selectionBorderWidth: CGFloat = 5
    
}
