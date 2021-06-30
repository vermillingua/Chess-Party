//
//  PlayerBuilder.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/27/21.
//

import SwiftUI

struct PlayerBuilder {
    var name: String
    var type: PlayerType
    var team: TeamID
    var icon: Image?

    public func buildPlayer(atIndex: Int, previousPlayer: Int, nextPlayerIndex: Int, withResponseHandler responseHandler: @escaping PlayerResponseHandler) -> Player {
        switch type {
        case .onDevice:
            return OnDevicePlayer(name: name,
                                  identity: PlayerID(id: atIndex),
                                  team: team,
                                  icon: PlayerIcon(systemString: "person"),
                                  nextPlayer: PlayerID(id: nextPlayerIndex),
                                  previousPlayer: PlayerID(id: previousPlayer),
                                  playerResponseHandler: responseHandler)
        case .computer:
            return ComputerPlayer(name: name,
                                  identity: PlayerID(id: atIndex),
                                  team: team,
                                  icon: PlayerIcon(systemString: "desktopcomputer"),
                                  nextPlayer: PlayerID(id: nextPlayerIndex),
                                  previousPlayer: PlayerID(id: previousPlayer),
                                  playerResponseHandler: responseHandler)
        case .remote:
            return RemotePlayer(name: name,
                                identity: PlayerID(id: atIndex),
                                team: team,
                                icon: PlayerIcon(systemString: "network"),
                                nextPlayer: PlayerID(id: nextPlayerIndex),
                                previousPlayer: PlayerID(id: previousPlayer),
                                playerResponseHandler: responseHandler)
        }
    }
}
