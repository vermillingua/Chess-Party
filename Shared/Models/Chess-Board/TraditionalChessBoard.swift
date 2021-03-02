//
//  RegularChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/14/21.
//

import Foundation

struct TraditionalChessBoard: TraditionalRulesChessBoard {
    
    var kingPosition = [PlayerID: Position]()
    var board: [Position : Piece]
    var rows: Int = 8
    var columns: Int = 8
    
    var castleableRooks = [PlayerID: Set<Position>]()
    var hasKingMoved = [PlayerID: Bool]()
    
    static var gameType: ChessGameType = .duel
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 0, column: 0)] = Piece(player: player2, type: .rook, team: team1)
        board[Position(row: 0, column: 1)] = Piece(player: player2, type: .knight, team: team1)
        board[Position(row: 0, column: 2)] = Piece(player: player2, type: .bishop, team: team1)
        board[Position(row: 0, column: 3)] = Piece(player: player2, type: .queen, team: team1)
        board[Position(row: 0, column: 4)] = Piece(player: player2, type: .king, team: team1)
        board[Position(row: 0, column: 5)] = Piece(player: player2, type: .bishop, team: team1)
        board[Position(row: 0, column: 6)] = Piece(player: player2, type: .knight, team: team1)
        board[Position(row: 0, column: 7)] = Piece(player: player2, type: .rook, team: team1)
        
        board[Position(row: 1, column: 0)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 1)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 2)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 3)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 4)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 5)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 6)] = Piece(player: player2, type: .pawn, team: team1)
        board[Position(row: 1, column: 7)] = Piece(player: player2, type: .pawn, team: team1)
        
        board[Position(row: 7, column: 0)] = Piece(player: player1, type: .rook, team: team2)
        board[Position(row: 7, column: 1)] = Piece(player: player1, type: .knight, team: team2)
        board[Position(row: 7, column: 2)] = Piece(player: player1, type: .bishop, team: team2)
        board[Position(row: 7, column: 3)] = Piece(player: player1, type: .queen, team: team2)
        board[Position(row: 7, column: 4)] = Piece(player: player1, type: .king, team: team2)
        board[Position(row: 7, column: 5)] = Piece(player: player1, type: .bishop, team: team2)
        board[Position(row: 7, column: 6)] = Piece(player: player1, type: .knight, team: team2)
        board[Position(row: 7, column: 7)] = Piece(player: player1, type: .rook, team: team2)
        
        board[Position(row: 6, column: 0)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 1)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 2)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 3)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 4)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 5)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 6)] = Piece(player: player1, type: .pawn, team: team2)
        board[Position(row: 6, column: 7)] = Piece(player: player1, type: .pawn, team: team2)

        kingPosition[player1] = Position(row: 7, column: 4)
        kingPosition[player2] = Position(row: 0, column: 4)
        
        hasKingMoved[player1] = false
        hasKingMoved[player2] = false
        
        castleableRooks[player1] = [Position(row: 7, column: 7), Position(row: 7, column: 0)]
        castleableRooks[player2] = [Position(row: 0, column: 7), Position(row: 0, column: 0)]
    }
    
    var enPassentPositions = [PlayerID: Position]()
    let pawnDoubleJumpPositions: [PlayerID : Set<Position>] = [player1: [Position(row: 6, column: 0), Position(row: 6, column: 1), Position(row: 6, column: 2), Position(row: 6, column: 3), Position(row: 6, column: 4), Position(row: 6, column: 5), Position(row: 6, column: 6), Position(row: 6, column: 7)], player2: [Position(row: 1, column: 0), Position(row: 1, column: 1), Position(row: 1, column: 2), Position(row: 1, column: 3), Position(row: 1, column: 4), Position(row: 1, column: 5), Position(row: 1, column: 6), Position(row: 1, column: 7)]]
    
    let pawnPromotionPositions: [PlayerID : Set<Position>] = [player1: [Position(row: 0, column: 0), Position(row: 0, column: 1), Position(row: 0, column: 2), Position(row: 0, column: 3), Position(row: 0, column: 4), Position(row: 0, column: 5), Position(row: 0, column: 6), Position(row: 0, column: 7)], player2: [Position(row: 7, column: 0), Position(row: 7, column: 1), Position(row: 7, column: 2), Position(row: 7, column: 3), Position(row: 7, column: 4), Position(row: 7, column: 5), Position(row: 7, column: 6), Position(row: 7, column: 7)]]

    let pawnMoveDirection: [PlayerID : Displacement] = [player1: .north, player2: .south]
    
    func getPositionName(_ position: Position) -> String {
        // MARK: TODO Again... all the things!
        return "TODO"
    }
    
    
}
