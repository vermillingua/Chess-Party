//
//  Player.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

let player1: PlayerID = PlayerID(id: 0)
let player2: PlayerID = PlayerID(id: 1)
let player3: PlayerID = PlayerID(id: 2)
let player4: PlayerID = PlayerID(id: 3)

let team1: TeamID = TeamID(id: 0)
let team2: TeamID = TeamID(id: 1)
let team3: TeamID = TeamID(id: 2)
let team4: TeamID = TeamID(id: 3)

protocol Player: Codable {
    var name: String { get }
    var type: PlayerType { get }
    var identity: PlayerID { get }
    var nextPlayer: PlayerID { get set }
    var previousPlayer: PlayerID { get set }
    var lastMove: Move? { get set }
    var team: TeamID { get }
    var icon: PlayerIcon { get set }
    var hasBeenEliminated: Bool { get set }
    var playerResponseHandler: PlayerResponseHandler? { get }

    func startMove(withBoard board: ChessBoard)
}

extension Player {
    var index: Int { identity.id }
}

enum PlayerType: Int, Codable {
    case onDevice, computer, remote
}

struct PlayerID: Hashable, Codable {
    var id: Int
    var index: Int { id }
}

struct TeamID: Hashable, Codable, Equatable {
    var id: Int
}

typealias PlayerResponseHandler = (Move) -> Void
