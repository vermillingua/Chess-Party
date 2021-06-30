//
//  ChessGameStore.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/20/21.
//

import Foundation

class ChessGameStore: ObservableObject {
    static var instance: ChessGameStore = ChessGameStore()
    var selectedGame: UUID? {
        didSet {
            objectWillChange.send()
        }
    }

    @Published var currentGames: [ChessGame]

    init() {
        let you = PlayerBuilder(name: "You", type: .onDevice, team: TeamID(id: 0))
        let teamy = PlayerBuilder(name: "Teamy", type: .computer,  team: TeamID(id: 0))
//        let A = PlayerBuilder(name: "First", type: .computer,  team: TeamID(id: 0))
        
        let chester = PlayerBuilder(name: "Chester", type: .computer, team: TeamID(id: 1))
        let remone = PlayerBuilder(name: "Remone", type: .remote,  team: TeamID(id: 1))
        let enimy = PlayerBuilder(name: "Enimy", type: .computer,  team: TeamID(id: 1))
        let B = PlayerBuilder(name: "Second", type: .computer,  team: TeamID(id: 1))
        let otherEnemy = PlayerBuilder(name: "Other Enimy with a very long name", type: .computer,  team: TeamID(id: 1))
        
        let C = PlayerBuilder(name: "Third", type: .onDevice,  team: TeamID(id: 2))
        
        let D = PlayerBuilder(name: "Fourth", type: .computer,  team: TeamID(id: 3))
        
        currentGames = [
            ChessGame(type: .duel, playerBuilders: [you, chester]),
            ChessGame(type: .duel, playerBuilders: [you, enimy]),
            ChessGame(type: .duel, playerBuilders: [you, remone]),
            ChessGame(type: .battle, playerBuilders: [you, enimy, teamy, otherEnemy]),
            ChessGame(type: .plusWar, playerBuilders: [you, B, C, D])
        ]
        selectedGame = currentGames.first?.id
    }
    
    
    func gameWillChange() {
        objectWillChange.send()
    }
}
