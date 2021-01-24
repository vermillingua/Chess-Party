//
//  ChessGameType.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

enum ChessGameType: String, CaseIterable {
    case duel = "Duel"
    case battle = "Battle"
 
    func description() -> String {
        switch self {
        case .duel:
            return "1v1 chess game following normal rules"
        case .battle:
            return "2v2 chess game on a 8x16 chess board following normal rules"
        }
    }
    
    func icon() -> Image {
        switch self {
        case .duel:
            return Image(systemName: "person.2")
        case .battle:
            return Image(systemName: "square.and.line.vertical.and.square")
        }
    }
    
    func gameMaker() -> some View {
        DuelGameMaker()
    }
    
    func gameView(game: ChessGame) -> some View {
        DuelGameView(boardView: ChessBoardView(chessGame: game))
    }
}

