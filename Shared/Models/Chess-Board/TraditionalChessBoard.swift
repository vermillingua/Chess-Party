//
//  TraditionalChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/9/21.
//

import Foundation

protocol TraditionalChessBoard: PrivateChessBoard {
    var enPassentSquare: Vector? { get set }
    var pawnMoveDirection: [PlayerID: Vector] { get }
    
    func getSlidingMoves(from start: Vector, in directions: [(Int, Int)]) -> [Move]
    func getJumpingMoves(from start: Vector, in directions: [(Int, Int)]) -> [Move]
    func isPlayerUnderAttack(_ player: PlayerID, at position: Vector) -> Bool
    func hasPawnMoved(position: Vector)
    
    func enemies(_ player1: PlayerID, _ player2: PlayerID) -> Bool
}

extension TraditionalChessBoard {
    func getSlidingMoves(from start: Vector, in directions: [Vector]) -> [Move] {
        var moves = [Move]()
        for direction in directions {
            var target = start + direction
            while (positionInBounds(target) && pieces[target] == nil) {
                moves.append(Move(actions: [MoveAction.travel(from: start, to: target)])) // Use smarter MoveAction constructors
            }
        }
        return moves
    }
}
