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
        do {
            let manager = FileManager.default
            var fileURL = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            fileURL?.appendPathComponent("currentGames")
            if let url = fileURL,  manager.fileExists(atPath: url.path){
                let json: Data = try Data(contentsOf: url)
                currentGames = try JSONDecoder().decode([ChessGame].self, from: json)
                print("Succesfully Loaded Games")
            } else {
                print ("Initializing Chess Game Store for the first time")
                currentGames = []
                firstInit()
            }
        } catch {
            print ("ERROR: Could not load data store: \(error)")
            currentGames = []
            firstInit()
        }
    }

    func firstInit() {
        currentGames = []
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
    
    static func saveGames() {
        do {
            var fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            fileURL?.appendPathComponent("currentGames")
            if let url = fileURL {
                let json: Data = try JSONEncoder().encode(ChessGameStore.instance.currentGames)
                try json.write(to: url)
                print("Games Saved")
                //            print("--------------\n\(String(describing: String(data: json, encoding: .utf8))) \n -------------")
            }
        } catch {
            print("Game Save Failed")
        }
    }
}
