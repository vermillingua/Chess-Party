//
//  Piece.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Piece: Identifiable {
    var player: PlayerID
    var type: PieceType
    var id: Int
    var position: Position?
    
    static var idCount = 0
    
    init(player: PlayerID, type: PieceType, position: Position? = nil) {
        self.player = player
        self.type = type
        id = Piece.idCount
        Piece.idCount += 1
        self.position = position
    }
}

enum PieceType {
    case pawn
    case knight
    case bishop
    case rook
    case queen
    case king
}
