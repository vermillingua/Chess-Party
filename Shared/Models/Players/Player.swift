//
//  Player.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

protocol Player {
    var name: String {get}
    var type: PlayerType {get}
    var team: Team? {get}
    var playerID: PlayerID {get}
    var playerResponseHandler: PlayerResponseHandler? {get set}
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler)
}

enum PlayerType {
    case onDevice, computer, remote
}

struct PlayerID: Identifiable {
    var id: Int
}

typealias PlayerResponseHandler = (Move) -> Bool
