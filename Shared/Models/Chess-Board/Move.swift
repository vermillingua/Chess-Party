//
//  Move.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Move: CustomStringConvertible {
    private(set) var actions: [MoveAction]
    
    /// The first travel actions's destination in the move. Note: Moves with multiple travel actions must order those MoveActions correctly.
    var primaryDestination: Position {
        var destination: Position?
        forloop: for action in actions {
            switch action {
            case .travel(_, let end):
                destination = end
                break forloop
            default:
                continue
            }
        }
        return destination!
    }
    
    var promotionType: PieceType? {
        for action in actions {
            switch action {
            case .spawn(_, let piece):
                return piece.type
            default:
                continue
            }
        }
        return nil
    }
    
    var captureSquare: Position? {
        for action in actions {
            switch action {
            case .remove(let position):
                return position
            default:
                continue
            }
        }
        return nil
    }
    
    var description: String {
        var desc = ""
        for i in 0..<actions.count {
            desc += "\(actions[i])"
            if i < actions.count-1 {
                desc += ", "
            }
        }
        return desc
    }
}

enum MoveAction: CustomStringConvertible {
    case travel(from: Position, to: Position)
    case remove(at: Position)
    case spawn(at: Position, piece: Piece)
    
    var description: String {
        switch self {
        case .travel(let from, let to):
            return "Travel \(from) --> \(to)"
        case .remove(let at):
            return "Remove Piece at \(at)"
        case .spawn(let at, let piece):
            return "Spawn \(piece.type) at \(at)"
        }
    }
}
