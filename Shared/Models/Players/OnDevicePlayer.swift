//
//  OnDevicePlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

struct OnDevicePlayer: Player {
    var name: String
    let type: PlayerType = .onDevice
    var id: PlayerID
    var team: TeamID
    var playerResponseHandler: PlayerResponseHandler?
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler) {
        playerResponseHandler = handler
    }
    
    func handleOnDeviceMove(_ move: Move) -> Bool {
        return playerResponseHandler!(move)
    }
}
