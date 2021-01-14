//
//  Piece.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Piece {
    var player: PlayerID
    var type: PieceType
}

enum PieceType {
    case pawn
    case knight
    case bishop
    case rook
    case queen
    case king
}
