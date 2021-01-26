//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct RenderablePiece: Identifiable {
    let piece: Piece
    var id: Int { piece.id }
    var position: Position
}

class ChessGame: ObservableObject, CustomStringConvertible, Identifiable {
    // MARK: - Board Identity
    let gameType: ChessGameType
    private(set) var id: UUID
    private(set) var players: [Player]
    private(set) var history: [ChessBoard]
    
    @Published private(set) var chessBoard: ChessBoard
    @Published private(set) var gameState: GameState
    
    var renderedChessPieces: [RenderablePiece] {
        var pieces = [RenderablePiece]()
        chessBoard.board.keys.forEach { position in
            pieces.append(RenderablePiece(piece: chessBoard.board[position]!, position: position))
        }
        return pieces
    }
    
    init(chessBoard: ChessBoard, playerBuilders: [PlayerBuilder], id: UUID = UUID()) {
        self.chessBoard = chessBoard
        self.id = id
        history = []
        potentialMoveDestinations = []
        warningPositions = []
        lastMoves = []
        gameType = type(of: chessBoard).gameType
        gameState = .paused

        players = []
        for builder in playerBuilders {
            players.append(builder.buildPlayer(withResponseHandler: {move in self.handleMove(move)} ))
        }
        gameState = .waitingOnPlayer(player: self.players.first!)
        self.players.first!.startMove(withBoard: chessBoard)

        enforcePlayerOrder(players: playerBuilders)
    }
    
    var description: String {
        var description = ""
        var teams: [String] = []
        var teamIDs: [TeamID] = []
        for player in players {
            if let index = teamIDs.firstIndex(where: { teamID in return teamID == player.team }) {
                teams[index] += ", \(player.name)"
            } else {
                teamIDs.append(player.team)
                teams.append(player.name)
            }
        }
        
        for teamIndex in 0..<teams.count {
            description += teamIndex == 0 ? teams[teamIndex] : " vs \(teams[teamIndex])"
        }
        return description
    }
    
    func enforcePlayerOrder(players: [PlayerBuilder]) {
        for index in 0..<players.count {
            assert(players[index].index == index, "Player ID's must equal their index in the order of players")
        }
    }
    

    // MARK: - View Events
    
    private var potentialMovesForCurrentPiece: [Move] = []
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
    
    enum SelectionType {
        case userFocus
        case potentialMove
        case warning
        case lastMove
    }
    
    func userTappedPosition(_ position: Position) {
        if gameState.isWaitingOnUserToMakeMove() {
            if (position == userFocusedPosition) {
                userFocusedPosition = nil
            } else if (potentialMoveDestinations.contains(position)) {
                if let userMove = potentialMovesForCurrentPiece.filter({$0.primaryDestination == position}).first,
                   let onDevicePlayer = gameState.getCurrentPlayer() as? OnDevicePlayer {
                    
                    potentialMoveDestinations.removeAll()
                    potentialMovesForCurrentPiece.removeAll()
                    userFocusedPosition = nil
                    onDevicePlayer.handleOnDeviceMove(userMove)
                }
            } else {
                if case .waitingOnPlayer(let currentPlayer) = gameState,
                   let piece = chessBoard.board[position],
                   piece.player == currentPlayer.identity {
    
                    userFocusedPosition = position
                    potentialMovesForCurrentPiece = chessBoard.getMoves(from: position)
                    potentialMoveDestinations.removeAll()
                    potentialMovesForCurrentPiece.forEach({potentialMoveDestinations.insert($0.primaryDestination)})
                }
            }
        }
    }
    
    func handleMove(_ move: Move) {
        // Make this move
        let _ = withAnimation(.interactiveSpring()) {
            chessBoard = chessBoard.doMove(move)
        }
        
        // Next players turn
        if let currentIndex = gameState.getCurrentPlayer()?.index {
            gameState = .waitingOnPlayer(player: players[(currentIndex + 1) % players.count])
            gameState.getCurrentPlayer()?.startMove(withBoard: chessBoard)
        }
        
    }
    
    // MARK: - States
    
    enum GameState {
        case paused
        case waitingOnPlayer(player: Player)
        case endedVictory(forTeam: TeamID)
        case endedStalemate
        
        func isWaitingOnUserToMakeMove() -> Bool {
            if let currentPlayer = getCurrentPlayer() {
                return currentPlayer.type == .onDevice
            } else {
                return false
            }
        }
        
        func getCurrentPlayer() -> Player? {
            if case .waitingOnPlayer(let currentPlayer) = self {
                return currentPlayer
            } else {
                return nil
            }
        }
    }
}

