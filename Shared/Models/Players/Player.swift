//
//  Player.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct PlayerBuilder {
    var name: String
    var type: PlayerType
    var identity: PlayerID
    var team: TeamID
    var icon: Image?
    
    var index: Int { identity.id }
    
    public func buildPlayer(withResponseHandler responseHandler: @escaping PlayerResponseHandler) -> Player {
        switch type {
        case .onDevice:
            return OnDevicePlayer(name: name, identity: identity, team: team, icon: icon ?? Image(systemName: "person"), playerResponseHandler: responseHandler)
        case .computer:
            return ComputerPlayer(name: name, identity: identity, team: team, icon: icon ?? Image(systemName: "desktopcomputer"), playerResponseHandler: responseHandler)
        case .remote:
            return RemotePlayer(name: name, identity: identity, team: team, icon: icon ?? Image(systemName: "network"), playerResponseHandler: responseHandler)
        }
    }
}

protocol Player {
    var name: String { get }
    var type: PlayerType { get }
    var identity: PlayerID { get }
    var team: TeamID { get }
    var icon: Image { get set }
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
}

struct TeamID: Hashable {
    var id: Int
}

typealias PlayerResponseHandler = (Move) -> Void
