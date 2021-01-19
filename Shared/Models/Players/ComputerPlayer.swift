//
//  ComputerPlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

struct ComputerPlayer: Player {
    var name: String
    var type: PlayerType = .computer
    var playerID: PlayerID
    var teamID: TeamID
    var playerResponseHandler: PlayerResponseHandler?
    
    init(name: String, playerID: PlayerID, teamID: TeamID? = nil, playerResponsehandler: PlayerResponseHandler? = nil) {
        self.name = name
        self.playerID = playerID
        self.teamID = teamID ?? TeamID(id: playerID.id)
        self.playerResponseHandler = playerResponsehandler
    }
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler) {
        playerResponseHandler = handler
    }
    
    
}
