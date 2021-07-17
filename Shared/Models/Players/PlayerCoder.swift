//
//  PlayerCoder.swift
//  Chess Party
//
//  Created by Robert Swanson on 6/29/21.
//

import Foundation
private enum playerCodingKeys: Int, CodingKey {
    case name
    case type
    case identity
    case nextPlayerID
    case previousPlayerID
    case lastMove
    case teamID
    case playerIcon
    case hasBeenEliminated
}

extension Player {
    init(from decoder: Decoder) throws {
        var onDevice: Self? = nil, computer: Self? = nil, remote: Self? = nil
        let container = try decoder.container(keyedBy: playerCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decode(PlayerType.self, forKey: .type)
        let identity = try container.decode(PlayerID.self, forKey: .identity)
        let nextPlayer = try container.decode(PlayerID.self, forKey: .nextPlayerID)
        let previousPlayer = try container.decode(PlayerID.self, forKey: .previousPlayerID)
        let lastMove = try container.decode(Move?.self, forKey: .lastMove)
        let team = try container.decode(TeamID.self, forKey: .teamID)
        let icon = try container.decode(PlayerIcon.self, forKey: .playerIcon)
        let hasBeenEliminated = try container.decode(Bool.self, forKey: .hasBeenEliminated)
        
        switch type {
        case .onDevice:
            onDevice = OnDevicePlayer(name: name, identity: identity, team: team, icon: icon, hasBeenEliminated: hasBeenEliminated, nextPlayer: nextPlayer, lastMove: lastMove, previousPlayer: previousPlayer, playerResponseHandler: nil) as? Self
        case .computer:
            computer = ComputerPlayer(name: name, identity: identity, team: team, icon: icon, hasBeenEliminated: hasBeenEliminated, nextPlayer: nextPlayer, lastMove: lastMove, previousPlayer: previousPlayer, playerResponseHandler: nil) as? Self
        case .remote:
            remote = RemotePlayer(name: name, identity: identity, team: team, icon: icon, hasBeenEliminated: hasBeenEliminated, nextPlayer: nextPlayer, lastMove: lastMove, previousPlayer: previousPlayer, playerResponseHandler: nil) as? Self
        }
        if let onDevice = onDevice {
            self = onDevice
        } else if let computer = computer {
            self = computer
        } else if let remote = remote {
            self = remote
        } else {
            throw PlayerCoder.PlayerTypeError.castError
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: playerCodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(identity, forKey: .identity)
        try container.encode(nextPlayer, forKey: .nextPlayerID)
        try container.encode(previousPlayer, forKey: .previousPlayerID)
        try container.encode(lastMove, forKey: .lastMove)
        try container.encode(team, forKey: .teamID)
        try container.encode(icon, forKey: .playerIcon)
        try container.encode(hasBeenEliminated, forKey: .hasBeenEliminated)
    }
}

struct PlayerCoder {
    static func encodeKeyed<Keys: CodingKey>(container: inout KeyedEncodingContainer<Keys>, key: Keys, player: Player) throws {
        switch player.type {
        case .onDevice:
            try container.encode(player as! OnDevicePlayer, forKey: key)
        case .computer:
            try container.encode(player as! ComputerPlayer, forKey: key)
        case .remote:
            try container.encode(player as! RemotePlayer, forKey: key)
        }
    }
    private static func encodeUnkeyed(container: inout UnkeyedEncodingContainer, player: Player) throws {
        switch player.type {
        case .onDevice:
            try container.encode(player as! OnDevicePlayer)
        case .computer:
            try container.encode(player as! ComputerPlayer)
        case .remote:
            try container.encode(player as! RemotePlayer)
        }
    }
    
    static func encodePlayerList(container: inout UnkeyedEncodingContainer, players: [Player]) throws {
        try players.forEach { player in
            try PlayerCoder.encodeUnkeyed(container: &container, player: player)
        }
    }
    
    static func decodeKeyed<Keys: CodingKey>(container: KeyedDecodingContainer<Keys>, key: Keys) throws -> Player {
        do {
            let onDevicePlayer = try container.decode(OnDevicePlayer.self, forKey: key)
            if (onDevicePlayer.type == .onDevice) {
                return onDevicePlayer
            }
        } catch {}
        do {
            let computerPlayer = try container.decode(ComputerPlayer.self, forKey: key)
            if (computerPlayer.type == .computer) {
                return computerPlayer
            }
        } catch {}
        do {
            let remotePlayer = try container.decode(RemotePlayer.self, forKey: key)
            if (remotePlayer.type == .remote) {
                return remotePlayer
            }
        } catch {}
        throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Unable to decode player")
    }
    
    private static func decodeUnkeyed(container: inout UnkeyedDecodingContainer) throws -> Player {
        do {
            let onDevicePlayer = try container.decode(OnDevicePlayer.self)
            if (onDevicePlayer.type == .onDevice) {
                return onDevicePlayer
            }
        } catch { }
        do {
            let computerPlayer = try container.decode(ComputerPlayer.self)
            if (computerPlayer.type == .computer) {
                return computerPlayer
            }
        } catch { }
        do {
            let remotePlayer = try container.decode(RemotePlayer.self)
            if (remotePlayer.type == .remote) {
                return remotePlayer
            }
        } catch { }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode player")
    }
    
    static func decodePlayerList(fromContainer container: inout UnkeyedDecodingContainer, handler: @escaping PlayerResponseHandler) throws -> [Player] {
        var players: [Player] = []
        while !container.isAtEnd {
            var player = try decodeUnkeyed(container: &container)
            player.playerResponseHandler = handler
            players.append(player)
        }
        return players
    }
    
    enum PlayerTypeError: Error {
        case unknownType(type: Player.Type)
        case castError
    }
}
