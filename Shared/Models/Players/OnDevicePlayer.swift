//
//  OnDevicePlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

struct OnDevicePlayer: Player {
    var name: String
    var type: PlayerType = .onDevice
    var team: Team?
    var playerID: PlayerID
    var playerResponseHandler: PlayerResponseHandler?
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler) {
        playerResponseHandler = handler
    }
    
    func handleOnDeviceMove(_ move: Move) -> Bool {
        return playerResponseHandler!(move)
    }
    
}
