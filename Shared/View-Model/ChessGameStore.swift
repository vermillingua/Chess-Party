//
//  ChessGameStore.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/20/21.
//

import Foundation

class ChessGameStore: ObservableObject {
    static var instance: ChessGameStore = ChessGameStore()

    @Published var currentGames: [ChessGame]

    init() {
        let you = PlayerBuilder(name: "You", type: .onDevice, team: TeamID(id: 0))
        let chester = PlayerBuilder(name: "Chester", type: .computer, team: TeamID(id: 1))
        let remone = PlayerBuilder(name: "Remone", type: .remote,  team: TeamID(id: 1))
        let teamy = PlayerBuilder(name: "Teamy", type: .onDevice,  team: TeamID(id: 0))
        let enimy = PlayerBuilder(name: "Enimy", type: .onDevice,  team: TeamID(id: 1))
        let otherEnemy = PlayerBuilder(name: "Other Enimy", type: .onDevice,  team: TeamID(id: 1))
        currentGames = [
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, chester]),
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, enimy]),
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, remone]),
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [you, enimy, teamy, otherEnemy]),
            ChessGame(chessBoard: TraditionalChessBoard(), playerBuilders: [remone, you])
        ]
    }
    
    func gameWillChange() {
        objectWillChange.send()
    }
}
