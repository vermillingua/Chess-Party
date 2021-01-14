//
//  RegularChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/14/21.
//

import Foundation

let white: PlayerID = PlayerID(id: 0)
let black: PlayerID = PlayerID(id: 1)

struct RegularChessBoard: TraditionalChessBoard {
    var board: [Position : Piece]
    var rows: Int = 8
    var columns: Int = 8
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 0, column: 0)] = Piece(player: black, type: .rook)
        board[Position(row: 0, column: 1)] = Piece(player: black, type: .knight)
        board[Position(row: 0, column: 2)] = Piece(player: black, type: .bishop)
        board[Position(row: 0, column: 3)] = Piece(player: black, type: .queen)
        board[Position(row: 0, column: 4)] = Piece(player: black, type: .king)
        board[Position(row: 0, column: 5)] = Piece(player: black, type: .bishop)
        board[Position(row: 0, column: 6)] = Piece(player: black, type: .knight)
        board[Position(row: 0, column: 7)] = Piece(player: black, type: .rook)
        
        board[Position(row: 1, column: 0)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 1)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 2)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 3)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 4)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 5)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 6)] = Piece(player: black, type: .pawn)
        board[Position(row: 1, column: 7)] = Piece(player: black, type: .pawn)
        
        board[Position(row: 7, column: 0)] = Piece(player: white, type: .rook)
        board[Position(row: 7, column: 1)] = Piece(player: white, type: .knight)
        board[Position(row: 7, column: 2)] = Piece(player: white, type: .bishop)
        board[Position(row: 7, column: 3)] = Piece(player: white, type: .queen)
        board[Position(row: 7, column: 4)] = Piece(player: white, type: .king)
        board[Position(row: 7, column: 5)] = Piece(player: white, type: .bishop)
        board[Position(row: 7, column: 6)] = Piece(player: white, type: .knight)
        board[Position(row: 7, column: 7)] = Piece(player: white, type: .rook)
        
        board[Position(row: 6, column: 0)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 1)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 2)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 3)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 4)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 5)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 6)] = Piece(player: white, type: .pawn)
        board[Position(row: 6, column: 7)] = Piece(player: white, type: .pawn)
        
        //Temporary
        kingPosition = [PlayerID: Position]()
    }
    
    var kingPosition: [PlayerID : Position] // MARK: TODO Update automaticially with an onSet watcher on the board struct.
    var enPassentPosition: Position?
    var pawnDoubleJumpPositions: [PlayerID : Set<Position>] = [white: [Position(row: 0, column: 6), Position(row: 1, column: 6), Position(row: 2, column: 6), Position(row: 3, column: 6), Position(row: 4, column: 6), Position(row: 5, column: 6), Position(row: 5, column: 6), Position(row: 7, column: 6)], black: [Position(row: 0, column: 1), Position(row: 1, column: 1), Position(row: 2, column: 1), Position(row: 3, column: 1), Position(row: 4, column: 1), Position(row: 5, column: 1), Position(row: 5, column: 1), Position(row: 7, column: 1)]]

    var pawnMoveDirection: [PlayerID : Displacement] = [white: .north, black: .south]
    
    func getPositionName(_ position: Position) -> String {
        // MARK: TODO Again... all the things!
        return "TODO"
    }
    
    
}
