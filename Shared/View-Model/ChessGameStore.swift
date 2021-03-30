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
        let enimy = PlayerBuilder(name: "Enimy", type: .computer,  team: TeamID(id: 1))
        let otherEnemy = PlayerBuilder(name: "Other Enimy", type: .computer,  team: TeamID(id: 1))
        currentGames = [
            ChessGame(chessBoard: ChessBoard1v1(), playerBuilders: [you, chester]),
            ChessGame(chessBoard: ChessBoard1v1(), playerBuilders: [you, enimy]),
            ChessGame(chessBoard: ChessBoard1v1(), playerBuilders: [you, remone]),
            ChessGame(chessBoard: ChessBoard1v1(), playerBuilders: [you, enimy, teamy, otherEnemy]),
            ChessGame(chessBoard: ChessBoard1v1(), playerBuilders: [remone, you]),
            ChessGame(chessBoard: ChessBoard2v2(), playerBuilders: [you, chester, enimy, otherEnemy])
        ]
    }
    
    func gameWillChange() {
        objectWillChange.send()
    }
}
