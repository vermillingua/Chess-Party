//
//  RemotePlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct RemotePlayer: Player {
    var name: String
    let type: PlayerType = .onDevice
    let identity: PlayerID
    let team: TeamID
    var icon: Image
    let playerResponseHandler: PlayerResponseHandler


    func startMove(withBoard board: ChessBoard) {
    }
    
}
