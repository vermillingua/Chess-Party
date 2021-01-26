//
//  ChessGameStore.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/20/21.
//

import Foundation

class ChessGameStore {
    static var instance: ChessGameStore = ChessGameStore()
    
    var currentGames: [ChessGame]

    init() {
        let you = PlayerBuilder(name: "You", type: .onDevice, identity: PlayerID(id: 0), team: TeamID(id: 0))
        let chester = PlayerBuilder(name: "Chester", type: .computer, identity: PlayerID(id: 1), team: TeamID(id: 1))
        let remone = PlayerBuilder(name: "Remone", type: .remote, identity: PlayerID(id: 1), team: TeamID(id: 1))
        let teamy = PlayerBuilder(name: "Teamy", type: .remote, identity: PlayerID(id: 2), team: TeamID(id: 0))
        let enimy = PlayerBuilder(name: "Enimy", type: .remote, identity: PlayerID(id: 3), team: TeamID(id: 1))
        currentGames = [
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, chester]),
           ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, remone]),
           ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, remone, teamy, enimy])
        ]
    }
}
