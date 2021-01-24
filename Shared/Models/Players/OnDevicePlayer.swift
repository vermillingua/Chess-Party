//
//  OnDevicePlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct OnDevicePlayer: Player {
    var name: String
    let type: PlayerType = .onDevice
    var id: PlayerID
    var team: TeamID
    var playerResponseHandler: PlayerResponseHandler?
    var icon: Image?
    
    mutating func startMove(withBoard board: ChessBoard, withPlayerResponseHandler handler: @escaping PlayerResponseHandler) {
        playerResponseHandler = handler
    }
    
    func handleOnDeviceMove(_ move: Move) -> Bool {
        return playerResponseHandler!(move)
    }
}
