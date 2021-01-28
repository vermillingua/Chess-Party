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
    var identity: PlayerID { get }
    var nextPlayer: PlayerID { get set }
    var previousPlayer: PlayerID { get set }
    var lastMove: Move? { get set }
    var team: TeamID { get }
    var icon: Image { get set }
    var hasBeenEliminated: Bool { get set }
    var playerResponseHandler: PlayerResponseHandler { get }

    func startMove(withBoard board: ChessBoard)
}

extension Player {
    var index: Int { identity.id }
}

enum PlayerType {
    case onDevice, computer, remote
}

struct PlayerID: Hashable {
    var id: Int
    var index: Int { id }
}

struct TeamID: Hashable {
    var id: Int
}

typealias PlayerResponseHandler = (Move) -> Void
