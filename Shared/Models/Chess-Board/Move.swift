//
//  Move.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Move {
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
}

enum MoveAction {
    case travel(from: Position, to: Position)
    case remove(at: Position)
    case spawn(at: Position, piece: Piece)
}
