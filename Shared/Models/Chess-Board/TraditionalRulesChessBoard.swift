//
//  TraditionalRulesChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/9/21.
//

import Foundation

protocol TraditionalRulesChessBoard: ChessBoard {
    var board: [Position: Piece] { get set }
    var kingPosition: [PlayerID: Position] { get }
    var enPassentPosition: Position? { get set } // MARK: TODO Make this a PlayerID dictionary.
    var pawnDoubleJumpPositions: [PlayerID: Set<Position>] { get }
    
    var queenMoveDirections: [Displacement] { get }
    var rookMoveDirections: [Displacement] { get }
    var bishopMoveDirections: [Displacement] { get }
    var kingMoveDirections: [Displacement] { get }
    var knightMoveDirections: [Displacement] { get }
    
    var pawnMoveDirection: [PlayerID: Displacement] { get }
    
    func doMove(_ move: Move) -> ChessBoard
    func isPositionSafe(_ position: Position, for player: PlayerID) -> Bool
}

extension TraditionalRulesChessBoard {
    
    var copy: TraditionalRulesChessBoard {
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
    
    func isPositionSafe(_ position: Position, for player: PlayerID) -> Bool {
        // MARK: TODO Uhh... Everything!
        return true
    }
    
    func doMove(_ move: Move) -> ChessBoard {
        var newBoard = self.copy
        
        // MARK: TODO If this is an en passent move we need to change the state of the enpassent square.
        
        newBoard.enPassentPosition = nil
        
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
    
    mutating func dummyMakeMove() {
        doMoveAction(MoveAction.travel(from: Position(row: 6, column: 0), to: Position(row: 4, column: 0)))
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
        return moves.filter { move in doMove(move).isKingInCheck(player: piece.player) }
    }
    
    func getKingMoves(from start: Position) -> [Move] {
        var moves = [Move]()
        moves += getJumpingMoves(from: start, towards: kingMoveDirections)
        // MARK: TODO Generate castle moves.
        return moves
    }
    
    func getPawnMoves(from start: Position) -> [Move] {
        var moves = [Move]()
        let pawn = board[start]!
        assert(pawn.type == PieceType.pawn)
        
        let displacement = pawnMoveDirection[pawn.player]!
    
        let upperRight = start.shift(by: displacement.rotatedClockwise)
        if let captee = board[upperRight], captee.player != pawn.player {
            moves.append(Move.getCaptureMove(from: start, to: upperRight))
        } else {
            let right = start.shift(by: displacement.rotatedClockwise.rotatedClockwise)
            if positionInBounds(upperRight), board[upperRight] == nil, right == enPassentPosition {
                moves.append(Move.getEnPassentMove(from: start, to: upperRight, capturing: right))
            }
        }
        
        let upperLeft = start.shift(by: displacement.rotatedCounterClockwise)
        if let captee = board[upperLeft], captee.player != pawn.player {
            moves.append(Move.getCaptureMove(from: start, to: upperLeft))
        } else {
            let left = start.shift(by: displacement.rotatedCounterClockwise.rotatedCounterClockwise)
            if positionInBounds(upperLeft), board[upperLeft] == nil, left == enPassentPosition {
                moves.append(Move.getEnPassentMove(from: start, to: upperRight, capturing: left))
            }
        }
        
        let up = start.shift(by: displacement)
        if positionInBounds(up), board[up] == nil {
            moves.append(Move.getTransitionMove(from: start, to: up))
            let upTwo = up.shift(by: displacement)
            if positionInBounds(upTwo), board[upTwo] == nil, pawnDoubleJumpPositions[pawn.player]!.contains(start) {
                moves.append(Move.getTransitionMove(from: start, to: upTwo))
            }
        }
        
        // MARK: TODO Generate promotion moves
        
        return moves
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
    
    static func getEnPassentMove(from start: Position, to end: Position, capturing: Position) -> Move {
        Move(actions: [MoveAction.remove(at: capturing), MoveAction.travel(from: start, to: end)])
    }
}
