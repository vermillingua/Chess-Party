//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

class ChessGame: ObservableObject {
    @Published var chessBoard: TraditionalChessBoard
    var chessPieces: [Piece] {
        var pieces = [Piece]()
        for position in chessBoard.board.keys {
            var piece = chessBoard.board[position]!
            piece.position = position
            pieces.append(piece)
        }
        return pieces
    }
    @Published var gameState: GameState
    

    @Published private(set) var userFocusedPosition: Position? {
        didSet {
            potentialMoveDestinations.removeAll()
            if let selectedPosition = userFocusedPosition {
                let possibleMoves = chessBoard.getMoves(from: selectedPosition)
                for move in possibleMoves {
                    potentialMoveDestinations.insert(move.primaryDestination)
                }
            }
        }
    }
    @Published private(set) var potentialMoveDestinations: Set<Position>
    @Published private(set) var warningPositions: Set<Position>
    @Published private(set) var lastMoves: Set<Position>
    

    var players: [Player]
    var history: [ChessBoard]
    
    init(chessBoard: TraditionalChessBoard, players: [Player]) {
        self.chessBoard = chessBoard
        self.players = players
        history = []
        gameState = .notStarted
        potentialMoveDestinations = []
        warningPositions = []
        lastMoves = []
    }
    
    enum SelectionType {
        case userFocus
        case potentialMove
        case warning
        case lastMove
    }
    
    enum GameState {
        case notStarted
        case paused
        case waitingOnPlayer(player: Player)
        case endedVictory(forTeam: Team)
        case endedStalemate
    }
    

    // MARK: - View Events
    func userTappedPosition(_ position: Position) {
        if (position == userFocusedPosition) {
            userFocusedPosition = nil
            chessBoard.dummyMakeMove()
        } else if (potentialMoveDestinations.contains(position)) {
            // TODO: Make Move
        } else {
            userFocusedPosition = position
        }
    }
}

