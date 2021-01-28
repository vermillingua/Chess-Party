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
    private(set) var playersInCheck: Set<PlayerID>
    

    @Published private(set) var chessBoard: ChessBoard
    @Published private(set) var gameState: GameState

    var currentPlayer: Player? { gameState.getCurrentPlayer()}
    var nextPlayer: Player? {
        if let nextPlayerIndex = currentPlayer?.nextPlayer.index {
            return players[nextPlayerIndex]
        } else { return nil }
    }
    var playersStillInGame: [PlayerID] {
        var identities: [PlayerID] = []
        players.filter { !$0.hasBeenEliminated }
            .forEach { player in identities.append(player.identity)}
        return identities
    }

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
        playersInCheck = Set<PlayerID>()
        gameType = type(of: chessBoard).gameType
        gameState = .paused

        players = []
        let playerCount = playerBuilders.count
        for builder in playerBuilders {
            let nextPlayer = (players.count == playerCount-1) ? 0 : players.count+1
            let previousPlayer = players.isEmpty ? playerCount-1 : players.count-1
            let responseHandler: PlayerResponseHandler = {move in self.handleMove(move)}
            players.append(builder.buildPlayer(atIndex: players.count, previousPlayer: previousPlayer, nextPlayerIndex: nextPlayer, withResponseHandler: responseHandler))
        }
        gameState = .waitingOnPlayer(player: self.players.first!)
        print("Starting: It's \(currentPlayer?.name ?? "nobody")'s turn!", gameState.isWaitingOnUserToMakeMove())
        self.players.first!.startMove(withBoard: chessBoard)
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
                if let userMove = potentialMovesForCurrentPiece.filter({ $0.primaryDestination == position}).first,
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
        if currentPlayer != nil {
            // Make this move
            let _ = withAnimation(.interactiveSpring()) {
                chessBoard = chessBoard.doMove(move)
            }
            
            updateGameState()
            objectWillChange.send()
            
            if let nextPlayer = currentPlayer {
                nextPlayer.startMove(withBoard: chessBoard)
            }
            
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
        
        func isWaitingOnComputer() -> Bool {
            if let currentPlayer = getCurrentPlayer() {
                return currentPlayer.type == .computer
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
    
    func updateGameState() {
        if let currentPlayerID = currentPlayer?.identity {
            ChessGameStore.instance.gameWillChange()
            playersInCheck.removeAll()
            warningPositions.removeAll()
            
            for player in players {
                if chessBoard.isKingInCheck(player: player.identity) {
                    playersInCheck.insert(player.identity)
    //                warningPositions.insert(chessBoard.getKingPosition(forPlayer: player))
                }
            }
            
            if chessBoard.canPlayerMakeMove(player: currentPlayerID) {
                gameState = .waitingOnPlayer(player: nextPlayer!)
            } else {
                if playersInCheck.contains(currentPlayerID) {
                    eliminatePlayer(playerID: currentPlayerID) // Player eliminated when can't make a move and in check
                } else {
                    if players.count == 2 {
                        gameState = .endedStalemate // 1v1 Games stalemated when player can't make move and isn't in check
                    } else {
                        eliminatePlayer(playerID: currentPlayerID) // Non 1v1 games eliminate player when they can't make a move
                    }
                }
            }
            
            
        }

        
    }
    
    func eliminatePlayer(playerID: PlayerID) {
        let player = players[playerID.index]
        
        players[playerID.index].hasBeenEliminated = true
        players[player.previousPlayer.id].nextPlayer = player.nextPlayer
        players[player.nextPlayer.id].previousPlayer = player.previousPlayer
        
        let inGame = playersStillInGame
        if inGame.count == 1 {
            gameState = .endedVictory(forTeam: players[inGame.first!.index].team)
        } else if inGame.count == 0 {
            gameState = .endedStalemate
        } else {
            updateGameState()
        }
    }
}

