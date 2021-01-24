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
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: PlayerID(id: 0), team: TeamID(id: 0)), ComputerPlayer(name: "Chester", id: PlayerID(id: 1), team: TeamID(id: 1))]),
           ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: PlayerID(id: 0), team: TeamID(id: 0)), RemotePlayer(name: "Remone", id: PlayerID(id: 1), team: TeamID(id: 1))]),
           ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: PlayerID(id: 0), team: TeamID(id: 0)), RemotePlayer(name: "Teamy", id: PlayerID(id: 1), team: TeamID(id: 1)), RemotePlayer(name: "Enemenimy", id: PlayerID(id: 2), team: TeamID(id: 2)), RemotePlayer(name: "Secondenimy", id: PlayerID(id: 3), team: TeamID(id: 3))])
        ]
    }
}
