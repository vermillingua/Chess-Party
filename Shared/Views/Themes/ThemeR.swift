//
//  Theme-D.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct ThemeR: Theme {
    let name: String = "Theme R"
    let primaryBoardColor: Color = Color.init(red: 62/255, green: 40/255, blue: 104/255)
    let secondaryBoardColor: Color = Color.init(red: 67/255, green: 145/255, blue: 199/255)
    
    func getImageFor(piece: Piece) -> Image {
        let playerID = piece.player.id
        switch piece.type {
        case .bishop: return Image("Theme-R-\(playerID)-Bishop")
        case .knight: return Image("Theme-R-\(playerID)-Knight")
        case .rook: return Image("Theme-R-\(playerID)-Rook")
        case .pawn: return Image("Theme-R-\(playerID)-Pawn")
        case .queen: return Image("Theme-R-\(playerID)-Queen")
        case .king: return Image("Theme-R-\(playerID)-King")
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
