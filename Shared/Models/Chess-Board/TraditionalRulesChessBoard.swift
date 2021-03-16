//
//  TraditionalRulesChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/9/21.
//

import Foundation

protocol TraditionalRulesChessBoard: ChessBoard {
    var board: [Position: Piece] { get set }
    var kingPosition: [PlayerID: Position] { get set }
    var enPassentPositions: [PlayerID: Position] { get set }
    var castleableRooks: [PlayerID: Set<Position>] { get set }
    var hasKingMoved: [PlayerID: Bool] { get set }
    
    var pawnDoubleJumpPositions: [PlayerID: Set<Position>] { get }
    var pawnPromotionPositions: [PlayerID: Set<Position>] { get }
    
    var queenMoveDirections: [Displacement] { get }
    var rookMoveDirections: [Displacement] { get }
    var bishopMoveDirections: [Displacement] { get }
    var kingMoveDirections: [Displacement] { get }
    var knightMoveDirections: [Displacement] { get }
    
    var pawnMoveDirection: [PlayerID: Displacement] { get }
}

extension TraditionalRulesChessBoard {
    
    var copy: TraditionalRulesChessBoard {
        self
    }
    
    var queenMoveDirections: [Displacement] { Displacement.allCompassDirections }
    var rookMoveDirections: [Displacement] { [.north, .south, .east, .west] }
    var bishopMoveDirections: [Displacement] { [.northeast, .northwest, .southeast, .southwest] }
    var kingMoveDirections: [Displacement] { Displacement.allCompassDirections }
    var knightMoveDirections: [Displacement] { [Displacement(x: 2, y: 1), Displacement(x: -2, y: 1), Displacement(x: 2, y: -1), Displacement(x: -2, y: -1), Displacement(x: 1, y: 2), Displacement(x: -1, y: 2), Displacement(x: 1, y: -2), Displacement(x: -1, y: -2)] }
    
    func canPlayerMakeMove(player: PlayerID) -> Bool {
        for (pos, piece) in board {
            if piece.player == player, getMoves(from: pos).count > 0 {
                return true
            }
        }
        return false
    }
    
    func isKingInCheck(player: PlayerID) -> Bool {
        let positionOfKing = kingPosition[player]!
        return !isPositionSafe(positionOfKing, for: board[positionOfKing]!.team)
    }
    
    func isPositionSafe(_ position: Position, for team: TeamID) -> Bool {
        for (pos, piece) in board {
            if piece.team != team {
                let moves = getUnsafeMoves(from: pos)
                for move in moves {
                    if move.primaryDestination == position {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func doMove(_ move: Move) -> ChessBoard {
        var newBoard = self.copy
        
        let start = move.primaryStart
        let end = move.primaryDestination
        let piece = newBoard.board[start]!
        
        if piece.type == PieceType.pawn, Position.getDisplacement(from: start, to: end) == newBoard.pawnMoveDirection[piece.player]!.scale(by: 2) {
            newBoard.enPassentPositions[piece.player] = end
        } else {
            newBoard.enPassentPositions.removeValue(forKey: piece.player)
        }
        
        if let captureSquare = move.captureSquare {
            newBoard.enPassentPositions.removeValue(forKey: board[captureSquare]!.player)
        }
        
        for action in move.actions {
            newBoard.doMoveAction(action)
        }
        
        return newBoard
    }
    
    mutating func doMoveAction(_ action: MoveAction) {
        switch action {
        case .remove(let position):
            assert(board[position] != nil)
            board.removeValue(forKey: position)
        case .spawn(let position, let piece):
            assert(board[position] == nil && positionInBounds(position))
            board[position] = piece
        case .travel(let start, let end):
            assert(board[start] != nil)
            assert(board[end] == nil, "\(String(describing: board[end])) && \(end)")
            assert(positionInBounds(end))
            let piece = board[start]!
            if piece.type == .king {
                kingPosition[piece.player] = end
                hasKingMoved[piece.player]! = true
            } else if board[start]!.type == PieceType.rook {
                castleableRooks[piece.player]!.remove(start)
            }
            board[end] = board.removeValue(forKey: start)
        }
    }

    func getMoves(from position: Position) -> [Move] {
        guard board[position] != nil else { return [Move]() }
        let piece = board[position]!
        var moves = getUnsafeMoves(from: position)
        moves += getCastleMoves(from: position)
        return moves.filter { move in !doMove(move).isKingInCheck(player: piece.player) }
    }
    
    func getUnsafeMoves(from start: Position) -> [Move] {
        guard board[start] != nil else { return [Move]() }
        var moves = [Move]()
        let piece = board[start]!
        switch piece.type {
        case .queen:
            moves += getSlidingMoves(from: start, towards: queenMoveDirections)
        case .bishop:
            moves += getSlidingMoves(from: start, towards: bishopMoveDirections)
        case .knight:
            moves += getJumpingMoves(from: start, towards: knightMoveDirections)
        case .rook:
            moves += getSlidingMoves(from: start, towards: rookMoveDirections)
        case .king:
            moves += getJumpingMoves(from: start, towards: kingMoveDirections)
        case .pawn:
            moves += getPawnMoves(from: start)
        }
        return moves
    }
    
    //MARK: TODO – Fix this code because it is ugly! Will need to make the Position and Displacement structures' code better and more clear
    func getCastleMoves(from start: Position) -> [Move] {
        guard board[start]!.type == PieceType.king else { return [Move]() }
        var moves = [Move]()
        let king = board[start]!
        for position in castleableRooks[king.player]! {
            assert(start.row == position.row || start.column == position.column)
            let kingMoveDirection = Position.getDisplacement(from: start, to: position)
            let normDirection = kingMoveDirection.normalize
            var target = start.shift(by: normDirection)
            var isClear = true
            for _ in 1..<(kingMoveDirection.scale) {
                if board[target] != nil {
                    isClear = false
                    break
                }
                target = target.shift(by: normDirection)
            }
            if isClear {
                target = start
                var isSafe = true
                for _ in 0..<((kingMoveDirection.scale + 1) / 2) {
                    if !isPositionSafe(target, for: king.team) {
                        isSafe = false
                        break
                    }
                    target = target.shift(by: normDirection)
                }
                if isSafe {
                    moves += [Move(actions: [MoveAction.travel(from: start, to: target), MoveAction.travel(from: position, to: target.shift(by: normDirection.scale(by: -1)))])]
                }
            }
        }
        return moves
    }
    
    func getPawnMoves(from start: Position) -> [Move] {
        var moves = [Move]()
        let pawn = board[start]!
        assert(pawn.type == PieceType.pawn)
        
        let displacement = pawnMoveDirection[pawn.player]!
    
        let upperRight = start.shift(by: displacement.rotatedClockwise)
        if let captee = board[upperRight], captee.team != pawn.team {
            moves.append(Move.getCaptureMove(from: start, to: upperRight))
        } else {
            for enPassentPosition in enPassentPositions.values {
                if pawn.team != board[enPassentPosition]!.team {
                    let right = start.shift(by: displacement.rotatedClockwise.rotatedClockwise)
                    if positionInBounds(upperRight), board[upperRight] == nil, right == enPassentPosition {
                        moves.append(Move.getEnPassentMove(from: start, to: upperRight, capturing: right))
                    }
                }
            }
        }
        
        let upperLeft = start.shift(by: displacement.rotatedCounterClockwise)
        if let captee = board[upperLeft], captee.team != pawn.team {
            moves.append(Move.getCaptureMove(from: start, to: upperLeft))
        } else {
            for enPassentPosition in enPassentPositions.values {
                if pawn.team != board[enPassentPosition]!.team {
                    let left = start.shift(by: displacement.rotatedCounterClockwise.rotatedCounterClockwise)
                    if positionInBounds(upperLeft), board[upperLeft] == nil, left == enPassentPosition {
                        moves.append(Move.getEnPassentMove(from: start, to: upperRight, capturing: left))
                    }
                }
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
        
        var finalMoves = [Move]()
        for move in moves {
            if pawnPromotionPositions[pawn.player]!.contains(move.primaryDestination) {
                var promotionActions = [[MoveAction]]()
                promotionActions.append([MoveAction]())
                promotionActions.append([MoveAction]())
                promotionActions.append([MoveAction]())
                promotionActions.append([MoveAction]())
                for action in move.actions {
                    switch action {
                    case .travel(let from, let to):
                        promotionActions[0] += [MoveAction.remove(at: from), MoveAction.spawn(at: to, piece: Piece(player: pawn.player, type: .queen, team: pawn.team))]
                        promotionActions[1] += [MoveAction.remove(at: from), MoveAction.spawn(at: to, piece: Piece(player: pawn.player, type: .rook, team: pawn.team))]
                        promotionActions[2] += [MoveAction.remove(at: from), MoveAction.spawn(at: to, piece: Piece(player: pawn.player, type: .bishop, team: pawn.team))]
                        promotionActions[3] += [MoveAction.remove(at: from), MoveAction.spawn(at: to, piece: Piece(player: pawn.player, type: .knight, team: pawn.team))]
                    default:
                        promotionActions[0].append(action)
                        promotionActions[1].append(action)
                        promotionActions[2].append(action)
                        promotionActions[3].append(action)
                    }
                }
                for actions in promotionActions {
                    finalMoves.append(Move(actions: actions))
                }
                
            } else {
                finalMoves.append(move)
            }
        }
        
        return finalMoves
    }
    
    func getSlidingMoves(from start: Position, towards displacements: [Displacement]) -> [Move] {
        var moves = [Move]()
        for displacement in displacements {
            var target = start.shift(by: displacement)
            while (positionInBounds(target) && board[target] == nil) {
                moves.append(Move.getTransitionMove(from: start, to: target))
                target = target.shift(by: displacement)
            }
            if let captee = board[target], captee.team != board[start]!.team {
                moves.append(Move.getCaptureMove(from: start, to: target))
            }
        }
        return moves
    }
    
    func getJumpingMoves(from start: Position, towards displacements: [Displacement]) -> [Move] {
        var moves = [Move]()
        for displacement in displacements {
            let target = start.shift(by: displacement)
            if positionInBounds(target), board[target] == nil {
                moves.append(Move.getTransitionMove(from: start, to: target))
            } else if let captee = board[target], captee.team != board[start]!.team {
                moves.append(Move.getCaptureMove(from: start, to: target))
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
