//
//  GameState.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

enum GameState {
    case notStarted
    case paused
    case waitingOnPlayer(player: Player)
    case endedVictory(forTeam: Team)
    case endedStalemate
}
