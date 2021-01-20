//
//  Theme.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct Theme {
    var themeType: ThemeType
    
    var primaryBoardColor: Color
    var secondaryBoardColor: Color
    
    typealias PieceImageGetter = (Piece) -> Image
    var pieceImageGetter: PieceImageGetter
    
    typealias SelectionColorGetter = (ChessGame.SelectionType) -> Color
    var selectionColorGetter: SelectionColorGetter
    var selectionBorderWidth: CGFloat
    
    init(themeType: ThemeType) {
        switch themeType {
        case .defaultTheme:
            self.init()
        case .themeD:
            self =  ThemeFactory.themeD()
        }
    }
    
    // MARK: - Default Theme
    
    static let defaultPieceImageGetter: PieceImageGetter = { piece in
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
    static let defaultSelectionColorGetter: SelectionColorGetter = { selection in
        switch selection {
        case .potentialMove: return Color.blue
        case .userFocus: return Color.yellow
        case .warning: return Color.red
        case .lastMove: return Color.orange
        }
    }
    
    fileprivate init (
        themeType: ThemeType = .defaultTheme,
        primaryBoardColor: Color = Color.init(red: 62/255, green: 40/255, blue: 104/255),
        secondaryBoardColor: Color = Color.init(red: 67/255, green: 145/255, blue: 199/255),
        pieceImageGetter: @escaping PieceImageGetter = Theme.defaultPieceImageGetter,
        selectionColorGetter: @escaping SelectionColorGetter = Theme.defaultSelectionColorGetter,
        selectionBorderWidth: CGFloat = 5) {
        
        self.themeType = themeType
        self.primaryBoardColor = primaryBoardColor
        self.secondaryBoardColor = secondaryBoardColor
        self.pieceImageGetter = pieceImageGetter
        self.selectionColorGetter = selectionColorGetter
        self.selectionBorderWidth = selectionBorderWidth
    }
}

enum ThemeType: String, CaseIterable {
    case defaultTheme = "Default"
    case themeD = "Theme D"
    
    var theme: Theme {
        Theme(themeType: self)
    }
}

private struct ThemeFactory {
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
        return Theme(themeType: .themeD, primaryBoardColor: .black, secondaryBoardColor: .gray, pieceImageGetter: getPieceImage)
    }
}
