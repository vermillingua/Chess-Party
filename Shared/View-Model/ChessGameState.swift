//
//  ChessGameState.swift
//  Chess Party (iOS)
//
//  Created by Robert Swanson on 7/13/21.
//

import Foundation

enum GameState: Codable {
    case paused
    case waitingOnPlayer(player: PlayerID)
    case endedVictory(forTeam: TeamID)
    case endedStalemate
    
    func isWaitingOnUserToMakeMove(game: ChessGame) -> Bool {
        if let currentPlayer = getCurrentPlayer() {
            return game.playerWithID(id: currentPlayer)?.type == .onDevice
        } else {
            return false
        }
    }
    
    func isWaitingOnComputer(game: ChessGame) -> Bool {
        if let currentPlayer = getCurrentPlayer() {
            return game.playerWithID(id: currentPlayer)?.type == .computer
        } else {
            return false
        }
    }
    
    func getCurrentPlayer() -> PlayerID? {
        if case .waitingOnPlayer(let currentPlayer) = self {
            return currentPlayer
            
        } else {
            return nil
        }
    }
    
    var gameOver: Bool {
        switch self {
        case .endedStalemate:
            return true
        case .endedVictory(_):
            return true
        default:
            return false
        }
    }
    
    // Codability
    enum GameStateCodingKeys: CodingKey {
        case state, waitingPlayer, winningTeam
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GameStateCodingKeys.self)
        let stateIndex = try container.decode(Int.self, forKey: .state)
        switch stateIndex {
        case 0:
            self = .paused
        case 1:
            self = .waitingOnPlayer(player: try container.decode(PlayerID.self, forKey: .waitingPlayer))
        case 2:
            self = .endedVictory(forTeam: try container.decode(TeamID.self, forKey: .winningTeam))
        case 3:
            self = .endedStalemate
        default:
            throw DecodingError.dataCorruptedError(forKey: .state, in: container, debugDescription: "Unrecognized game state")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GameStateCodingKeys.self)
        switch self {
        case .paused:
            try container.encode(0, forKey: .state)
        case .waitingOnPlayer(let player):
            try container.encode(1, forKey: .state)
            try container.encode(player, forKey: .waitingPlayer)
        case .endedVictory(let forTeam):
            try container.encode(2, forKey: .state)
            try container.encode(forTeam, forKey: .winningTeam)
        case .endedStalemate:
            try container.encode(3, forKey: .state)
        }
    }
}
