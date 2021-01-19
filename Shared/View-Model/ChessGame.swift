//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

class ChessGame: ObservableObject, CustomStringConvertible, Identifiable {
    var gameType: ChessGameType
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
    
    var id: UUID

    var players: [Player]
    var history: [ChessBoard]
    
    var description: String {
        var description = ""
        var teams: [String] = []
        var teamIDs: [TeamID] = []
        for player in players {
            if let index = teamIDs.firstIndex(where: { teamID in return teamID == player.teamID }) {
                teams[index] += ", \(player.name)"
            } else {
                teamIDs.append(player.teamID)
                teams.append(player.name)
            }
        }
        
        for teamIndex in 0..<teams.count {
            description += teamIndex == 0 ? teams[teamIndex] : " vs \(teams[teamIndex])"
        }
        return description
    }
    
    init(chessBoard: TraditionalChessBoard, players: [Player], id: UUID = UUID()) {
        self.chessBoard = chessBoard
        self.players = players
        self.id = id
        history = []
        gameState = .notStarted
        potentialMoveDestinations = []
        warningPositions = []
        lastMoves = []
        gameType = type(of: chessBoard).gameType
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
        case endedVictory(forTeam: TeamID)
        case endedStalemate
    }
    

    // MARK: - View Events
    func userTappedPosition(_ position: Position) {
        if (position == userFocusedPosition) {
            userFocusedPosition = nil
            withAnimation(.interactiveSpring()) {
                chessBoard.dummyMakeMove()
            }
        } else if (potentialMoveDestinations.contains(position)) {
            // TODO: Make Move
        } else {
            userFocusedPosition = position
        }
    }
}

