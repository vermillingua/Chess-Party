//
//  ChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

protocol ChessBoard {
    var pieces: [Position: Piece] { get }
    var rows: Int { get }
    var columns: Int { get }
    
    func getMoves(player: PlayerID) -> [Move]
    func getMoves(position: Position) -> [Move]
    mutating func doMove(_ move: Move)
    func isKingInCheck(player: PlayerID) -> Bool
}

protocol PrivateChessBoard: ChessBoard {
    var pieces: [Position: Piece] { get set }
    
    func positionInBounds(_ position: Position) -> Bool
}

extension PrivateChessBoard {
    func getMoves(player: PlayerID) -> [Move] {
        var moves = [Move]()
        for position in pieces.keys {
            moves += getMoves(position: position)
        }
        return moves
    }
    
    mutating func doMove(_ move: Move) {
        for action in move.actions {
            doMoveAction(action)
        }
    }
    
    mutating func doMoveAction(_ action: MoveAction) {
        switch action {
        case .travel(let start, let end):
            assert(pieces[start] != nil && pieces[end] == nil)
            pieces[end] = pieces.removeValue(forKey: start)
        case .remove(let position):
            assert(pieces[position] != nil)
            pieces.removeValue(forKey: position)
        case .spawn(let position, let piece):
            assert(pieces[position] == nil)
            pieces[position] = piece
        }
    }
    
    func positionInBounds(_ position: Position) -> Bool {
        let row = position.getRow()
        let column = position.getColumn()
        return 0 <= row && row < rows && 0 <= column && column < columns
    }
}
