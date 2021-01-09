//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

class ChessGame {
    @Published var chessBoard: ChessBoard
    @Published var gameState: GameState
    @Published var selectedPositions: [Position: SelectionType]

    var players: [Player]
    var history: [ChessBoard]
    
    init(chessBoard: ChessBoard, players: [Player]) {
        self.chessBoard = chessBoard
        self.players = players
        history = []
        gameState = .notStarted
        selectedPositions = [:]
    }
    
    // MARK: - View Events
    func userTappedPosition(_ position: Position) {
        
    }
    
}

