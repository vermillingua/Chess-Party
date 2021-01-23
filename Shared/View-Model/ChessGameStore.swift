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
        currentGames = [
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), ComputerPlayer(name: "Chester", playerID: PlayerID(id: 1))]),
           ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), RemotePlayer(name: "Remone", playerID: PlayerID(id: 1))]),
           ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), RemotePlayer(name: "Teamy", playerID: PlayerID(id: 1)), RemotePlayer(name: "Enemenimy", playerID: PlayerID(id: 2)), RemotePlayer(name: "Secondenimy", playerID: PlayerID(id: 3))])
        ]
    }
}
