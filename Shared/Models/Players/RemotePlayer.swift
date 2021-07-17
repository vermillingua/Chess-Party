//
//  RemotePlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct RemotePlayer: Player {
    var name: String
    let type: PlayerType = .remote
    let identity: PlayerID
    let team: TeamID
    var icon: PlayerIcon
    var hasBeenEliminated: Bool = false
    var nextPlayer: PlayerID
    var lastMove: Move? = nil
    var previousPlayer: PlayerID
    var playerResponseHandler: PlayerResponseHandler?

    func startMove(withBoard board: ChessBoard) {
    }
    
}
