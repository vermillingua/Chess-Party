//
//  Move.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Move: CustomStringConvertible, Codable {
    private(set) var actions: [MoveAction]
    
    /// The first travel actions's destination in the move. Note: Moves with multiple travel actions must order those MoveActions correctly.
    var primaryDestination: Position {
        var destination: Position?
        forloop: for action in actions {
            switch action {
            case .travel(_, let end):
                destination = end
                break forloop
            case .spawn(let at, _):
                destination = at
                break forloop
            default:
                continue
            }
        }
        return destination!
    }
    
    var primaryStart: Position {
        var destination: Position?
        forloop: for action in actions {
            switch action {
            case .travel(let from, _):
                destination = from
                break forloop
            case .remove(let at):
                destination = at
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

enum MoveAction: CustomStringConvertible, Codable {
    private enum codingKeys: String, CodingKey {
        case kind
        case from
        case to
        case at
        case piece
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        
        if let kind = try? container.decode(Int.self, forKey: .kind) {
            switch kind {
            case 0:
                if let from = try? container.decode(Position.self, forKey: .from), let to = try? container.decode(Position.self, forKey: .to) {
                    self = .travel(from: from, to: to)
                    return
                }
            case 1:
                if let at = try? container.decode(Position.self, forKey: .at) {
                    self = .remove(at: at)
                    return
                }
            case 2:
                if let at = try? container.decode(Position.self, forKey: .at), let piece = try? container.decode(Piece.self, forKey: .piece) {
                    self = .spawn(at: at, piece: piece)
                    return
                }
            default:
                throw DecodingError.dataCorruptedError(forKey: codingKeys.kind, in: container, debugDescription: "Out of bounds move action kind")
            }
        }
        throw DecodingError.dataCorruptedError(forKey: codingKeys.kind, in: container, debugDescription: "No move action kind defined")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        switch self {
        case .travel(let from, let to):
            try container.encode(0, forKey: .kind)
            try container.encode(from, forKey: .from)
            try container.encode(to, forKey: .to)
        case .remove(let at):
            try container.encode(1, forKey: .kind)
            try container.encode(at, forKey: .at)
        case .spawn(let at, let piece):
            try container.encode(2, forKey: .kind)
            try container.encode(at, forKey: .at)
            try container.encode(piece, forKey: .piece)
        }
    }
    
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
