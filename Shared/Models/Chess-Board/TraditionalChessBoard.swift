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
    var enPassentPosition: Position? { get set }
    
    var queenMoveDirections: [Displacement] { get }
    var rookMoveDirections: [Displacement] { get }
    var bishopMoveDirections: [Displacement] { get }
    var kingMoveDirections: [Displacement] { get }
    var knightMoveDirections: [Displacement] { get }
    
    var pawnMoveDirection: [PlayerID: Displacement] { get }
    
    func doMove(_ move: Move) -> ChessBoard
    func isPositionSafe(_ position: Position, for player: PlayerID) -> Bool
}

extension TraditionalChessBoard {
    
    var copy: TraditionalChessBoard {
        self
    }
    
    var queenMoveDirections: [Displacement] { Displacement.allCompassDirections }
    var rookMoveDirections: [Displacement] { [.north, .south, .east, .west] }
    var bishopMoveDirections: [Displacement] { [.northeast, .northwest, .southeast, .southwest] }
    var kingMoveDirections: [Displacement] { Displacement.allCompassDirections }
    var knightMoveDirections: [Displacement] { [Displacement(x: 3, y: 1), Displacement(x: -3, y: 1), Displacement(x: 3, y: -1), Displacement(x: -3, y: -1), Displacement(x: 1, y: 3), Displacement(x: -1, y: 3), Displacement(x: 1, y: -3), Displacement(x: -1, y: -3)] }
    
    
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
            assert(board[position] == nil && positionInBounds(position))
            board[position] = piece
        case .travel(let start, let end):
            assert(board[start] != nil && board[end] == nil && positionInBounds(end))
            board[end] = board.removeValue(forKey: start)
        }
    }
    
    func getMoves(from position: Position) -> [Move] {
        var moves = [Move]()
        let piece = board[position]!
        switch piece.type {
        case .queen:
            moves += getSlidingMoves(from: position, towards: queenMoveDirections)
        case .bishop:
            moves += getSlidingMoves(from: position, towards: bishopMoveDirections)
        case .knight:
            moves += getJumpingMoves(from: position, towards: knightMoveDirections)
        case .rook:
            moves += getSlidingMoves(from: position, towards: rookMoveDirections)
        case .king:
            moves += getKingMoves(from: position)
        case .pawn:
            moves += getPawnMoves(from: position)
        }
        // MARK: TODO Filter out illegal moves that either put the king in check or leave the king in check.
        return moves
    }
    
    func getKingMoves(from start: Position) -> [Move] {
        
    }
    
    func getPawnMoves(from start: Position) -> [Move] {
        
    }
    
    func getSlidingMoves(from start: Position, towards displacements: [Displacement]) -> [Move] {
        var moves = [Move]()
        for displacement in displacements {
            var target = start.shift(by: displacement)
            while (positionInBounds(target) && board[target] == nil) {
                moves.append(Move.getTransitionMove(from: start, to: target))
                target = target.shift(by: displacement)
            }
            if let captee = board[target], captee.player != board[start]!.player {
                moves.append(Move.getCaptureMove(from: start, to: target))
            }
        }
        return moves
    }
    
    func getJumpingMoves(from start: Position, towards displacements: [Displacement]) -> [Move] {
        var moves = [Move]()
        for displacement in displacements {
            let target = start.shift(by: displacement)
            if let captee = board[target], captee.player != board[start]!.player {
                moves.append(Move.getCaptureMove(from: start, to: target))
            } else if positionInBounds(target) {
                moves.append(Move.getTransitionMove(from: start, to: target))
            }
        }
        return moves
    }
}

fileprivate extension Move {
    
    static func getTransitionMove(from start: Position, to end: Position) -> Move {
        Move(actions: [MoveAction.travel(from: start, to: end)])
    }
    
    static func getCaptureMove(from start: Position, to end: Position) -> Move {
        Move(actions: [MoveAction.remove(at: end), MoveAction.travel(from: start, to: end)])
    }
}
