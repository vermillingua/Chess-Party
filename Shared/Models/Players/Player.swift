//
//  Player.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

protocol Player {
    var name: String { get }
    var type: PlayerType { get }
    var id: PlayerID { get }
    var team: TeamID { get }
    var playerResponseHandler: PlayerResponseHandler? { get set }
    var icon: Image? { get set }
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler)
}

enum PlayerType {
    case onDevice, computer, remote
}

struct PlayerID: Hashable {
    var id: Int
}

struct TeamID: Hashable {
    var id: Int
}

typealias PlayerResponseHandler = (Move) -> Bool
