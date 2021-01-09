//
//  Move.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Move {
    private(set) var actions: [MoveAction]
    
    func getAlgebraicString() -> String? {
        return "" // TODO
    }
}

enum MoveAction {
    case travel(from: Position, to: Position)
    case remove(at: Position)
    case spawn(at: Position, piece: Piece)
}
