//
//  Theme.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct Theme {
    var themeType: ThemeType
    
    let primaryBoardColor: Color
    let secondaryBoardColor: Color
    
    typealias PieceImageGetter = (PieceType, PlayerID) -> Image
    let pieceImageGetter: PieceImageGetter
    
    typealias SelectionColorGetter = (ChessGame.SelectionType) -> Color
    let selectionColorGetter: SelectionColorGetter
    let selectionBorderWidth: CGFloat
    
    
    init(themeType: ThemeType) {
        switch themeType {
        case .defaultTheme:
            self.init()
        case .themeD:
            self =  ThemeFactory.themeD()
        }
    }
    
    // MARK: - Default Theme
    
    static let defaultPieceImageGetter: PieceImageGetter = { (pieceType, playerID) in
        switch pieceType {
        case .bishop: return Image("Theme-R-\(playerID.id)-Bishop")
        case .knight: return Image("Theme-R-\(playerID.id)-Knight")
        case .rook: return Image("Theme-R-\(playerID.id)-Rook")
        case .pawn: return Image("Theme-R-\(playerID.id)-Pawn")
        case .queen: return Image("Theme-R-\(playerID.id)-Queen")
        case .king: return Image("Theme-R-\(playerID.id)-King")
        }
    }
    static let defaultSelectionColorGetter: SelectionColorGetter = { selection in
        switch selection {
        case .potentialMove: return Color.orange
        case .userFocus: return Color.yellow
        case .warning: return Color.red
        case .lastMove: return Color.pink
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
        let getPieceImage: (PieceType, PlayerID) -> Image = { (pieceType, playerID) in
            switch pieceType {
            case .bishop: return Image("Theme-D-\(playerID.id)-Bishop")
            case .knight: return Image("Theme-D-\(playerID.id)-Knight")
            case .rook: return Image("Theme-D-\(playerID.id)-Rook")
            case .pawn: return Image("Theme-D-\(playerID.id)-Pawn")
            case .queen: return Image("Theme-D-\(playerID.id)-Queen")
            case .king: return Image("Theme-D-\(playerID.id)-King")
            }
        }
        let selectionColorGetter: Theme.SelectionColorGetter = { type in
            switch type {
            case .lastMove:
                return Color.blue
            case .potentialMove:
                return Color.white
            case .userFocus:
                return Color.yellow
            case .warning:
                return Color.red
            }
        }
        return Theme(themeType: .themeD, primaryBoardColor: .black, secondaryBoardColor: .gray, pieceImageGetter: getPieceImage, selectionColorGetter: selectionColorGetter)
    }
}
