//
//  Theme.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct Theme {
    var name: String = "Default"
    
    // MARK: - Board Tiles
    var primaryBoardColor = Color.init(red: 62/255, green: 40/255, blue: 104/255)
    var secondaryBoardColor = Color.init(red: 67/255, green: 145/255, blue: 199/255)

    // MARK: - Pieces
    var getPieceImage: (Piece) -> Image = { piece in
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
    
    // MARK: - Select
    var colorForSelection: (SelectionType) -> Color = { selection in
        switch selection {
        case .potentialMove: return Color.blue
        case .userFocus: return Color.yellow
        case .warning: return Color.red
        }
    }
    
    var selectionBorderWidth: CGFloat = 5
}

struct ThemeFactory {
    static func themeD() -> Theme {
        let getPieceImage: (Piece) -> Image = { piece in
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
        
        return Theme(name: "Theme D",
              primaryBoardColor: Color.black,
              secondaryBoardColor: Color.gray,
              getPieceImage: getPieceImage
              )
    }
}
