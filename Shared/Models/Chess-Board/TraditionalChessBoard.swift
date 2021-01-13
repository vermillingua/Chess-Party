//
//  TraditionalChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/9/21.
//

import Foundation

protocol TraditionalChessBoard: ChessBoard {
    var board: [Position: Piece] { get set }
    var kingPosition: [PlayerID: Position] { get }
    
    func doMove(_ move: Move) -> ChessBoard
    func isPositionSafe(_ position: Position, for player: PlayerID) -> Bool
}

extension TraditionalChessBoard {
    
    var copy: TraditionalChessBoard {
        self
    }
    
    func isKingInCheck(player: PlayerID) -> Bool {
        isPositionSafe(kingPosition[player]!, for: player)
    }
    
    func doMove(_ move: Move) -> ChessBoard {
        var newBoard = self.copy
        for action in move.actions {
            newBoard.doMoveAction(action)
        }
        return newBoard
    }
    
    mutating func doMoveAction(_ action: MoveAction) {
        switch action {
        case .remove(let position):
            assert(board[position] != nil)
            board[position] = nil
        case .spawn(let position, let piece):
            assert(board[position] == nil)
            board[position] = piece
        case .travel(let start, let end):
            assert(board[start] != nil && board[end] == nil)
            board[end] = board.removeValue(forKey: start)
        }
    }
}
