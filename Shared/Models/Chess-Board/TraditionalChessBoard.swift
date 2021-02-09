//
//  RegularChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/14/21.
//

import Foundation

let white: PlayerID = PlayerID(id: 0)
let black: PlayerID = PlayerID(id: 1)

let team1: TeamID = TeamID(id: 0)
let team2: TeamID = TeamID(id: 1)

struct TraditionalChessBoard: TraditionalRulesChessBoard {
    
    var kingPosition = [PlayerID: Position]()
    var board: [Position : Piece]
    var rows: Int = 8
    var columns: Int = 8
    
    static var gameType: ChessGameType = .duel
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 0, column: 0)] = Piece(player: black, type: .rook, team: team1)
        board[Position(row: 0, column: 1)] = Piece(player: black, type: .knight, team: team1)
        board[Position(row: 0, column: 2)] = Piece(player: black, type: .bishop, team: team1)
        board[Position(row: 0, column: 3)] = Piece(player: black, type: .queen, team: team1)
        board[Position(row: 0, column: 4)] = Piece(player: black, type: .king, team: team1)
        board[Position(row: 0, column: 5)] = Piece(player: black, type: .bishop, team: team1)
        board[Position(row: 0, column: 6)] = Piece(player: black, type: .knight, team: team1)
        board[Position(row: 0, column: 7)] = Piece(player: black, type: .rook, team: team1)
        
        board[Position(row: 1, column: 0)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 1)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 2)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 3)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 4)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 5)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 6)] = Piece(player: black, type: .pawn, team: team1)
        board[Position(row: 1, column: 7)] = Piece(player: black, type: .pawn, team: team1)
        
        board[Position(row: 7, column: 0)] = Piece(player: white, type: .rook, team: team2)
        board[Position(row: 7, column: 1)] = Piece(player: white, type: .knight, team: team2)
        board[Position(row: 7, column: 2)] = Piece(player: white, type: .bishop, team: team2)
        board[Position(row: 7, column: 3)] = Piece(player: white, type: .queen, team: team2)
        board[Position(row: 7, column: 4)] = Piece(player: white, type: .king, team: team2)
        board[Position(row: 7, column: 5)] = Piece(player: white, type: .bishop, team: team2)
        board[Position(row: 7, column: 6)] = Piece(player: white, type: .knight, team: team2)
        board[Position(row: 7, column: 7)] = Piece(player: white, type: .rook, team: team2)
        
        board[Position(row: 6, column: 0)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 1)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 2)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 3)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 4)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 5)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 6)] = Piece(player: white, type: .pawn, team: team2)
        board[Position(row: 6, column: 7)] = Piece(player: white, type: .pawn, team: team2)

        kingPosition[white] = Position(row: 7, column: 4)
        kingPosition[black] = Position(row: 0, column: 4)
    }
    
    //var kingPosition: [PlayerID : Position] // MARK: TODO Update automaticially with an onSet watcher on the board struct.
    var enPassentPositions = [PlayerID: Position]()
    var pawnDoubleJumpPositions: [PlayerID : Set<Position>] = [white: [Position(row: 6, column: 0), Position(row: 6, column: 1), Position(row: 6, column: 2), Position(row: 6, column: 3), Position(row: 6, column: 4), Position(row: 6, column: 5), Position(row: 6, column: 6), Position(row: 6, column: 7)], black: [Position(row: 1, column: 0), Position(row: 1, column: 1), Position(row: 1, column: 2), Position(row: 1, column: 3), Position(row: 1, column: 4), Position(row: 1, column: 5), Position(row: 1, column: 6), Position(row: 1, column: 7)]]
    
    var pawnPromotionPositions: [PlayerID : Set<Position>] = [white: [Position(row: 0, column: 0), Position(row: 0, column: 1), Position(row: 0, column: 2), Position(row: 0, column: 3), Position(row: 0, column: 4), Position(row: 0, column: 5), Position(row: 0, column: 6), Position(row: 0, column: 7)], black: [Position(row: 7, column: 0), Position(row: 7, column: 1), Position(row: 7, column: 2), Position(row: 7, column: 3), Position(row: 7, column: 4), Position(row: 7, column: 5), Position(row: 7, column: 6), Position(row: 7, column: 7)]]

    var pawnMoveDirection: [PlayerID : Displacement] = [white: .north, black: .south]
    
    func getPositionName(_ position: Position) -> String {
        // MARK: TODO Again... all the things!
        return "TODO"
    }
    
    
}
