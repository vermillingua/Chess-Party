//
//  Piece.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Piece: Identifiable, Codable {
    var player: PlayerID
    var team: TeamID
    var type: PieceType
    var id: Int
    
    static var idCount = 0
    
    init(player: PlayerID, type: PieceType, team: TeamID) {
        self.player = player
        self.type = type
        self.team = team
        id = Piece.idCount
        Piece.idCount += 1
    }
    
    //MARK: TODO Add easier constructor?
}

enum PieceType: String, Codable {
    case pawn
    case knight
    case bishop
    case rook
    case queen
    case king
}
