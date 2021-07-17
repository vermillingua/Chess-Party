//
//  ChessGameStore.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/20/21.
//

import Foundation

let CURRENT_GAMES_FILE = "currentGames.json"

class ChessGameStore: ObservableObject {
    static var instance: ChessGameStore = ChessGameStore()
    var selectedGame: UUID? {
        didSet {
            objectWillChange.send()
        }
    }

    @Published var currentGames: [ChessGame]
    
    private let fileManager = FileManager.default
    private let savedGamesDir: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("savedGames")
    
    init() {
        currentGames = []
        if let url = savedGamesDir {
            let enumerator = fileManager.enumerator(atPath: url.path)
            while let filename = enumerator?.nextObject() as? String {
                do {
                    let json: Data = try Data(contentsOf: getGamePath(filename: filename)!)
                    let game = try JSONDecoder().decode(ChessGame.self, from: json)
                    currentGames.append(game)
                } catch {
                    print("ERROR: Could not load file: \(filename) error:\n\(error)")
                }
            }
        }
        if currentGames.isEmpty {
            firstInit()
        }
    }
               
    private func getGamePath(filename: String) -> URL? {
        var fileURL = savedGamesDir
        do {
            try fileManager.createDirectory(at: fileURL!, withIntermediateDirectories: true, attributes: nil)
        } catch {}
        fileURL?.appendPathComponent(filename)
        return fileURL
    }
    
    func saveGame(game: ChessGame) {
        do {
            if let url = getGamePath(filename: "\(game.id.uuidString).json") {
                let json: Data = try JSONEncoder().encode(game)
                try json.write(to: url, options: .atomicWrite)
            }
        } catch {
            print("Failed to save game \(game.id.uuidString): \n\(error)")
        }
    }
    
    func saveAll() {
        currentGames.forEach(){ game in saveGame(game: game)}
    }
    
    func deleteGame(game: ChessGame) {
        do {
            if let url = getGamePath(filename: "\(game.id.uuidString).json") {
                try fileManager.removeItem(at: url)
            }
            let index = currentGames.firstIndex(where: {g in game.id == g.id})
            if let idx = index {
                currentGames.remove(at: idx)
            }
        } catch {
            print("ERROR: Failed to delete game \(game.id.uuidString):\n\(error)")
        }
    }
    
    func resetGames() {
        currentGames.forEach(){ game in deleteGame(game: game)}
        firstInit()
        saveAll()
    }

    private func firstInit() {
        currentGames = []
        let you = PlayerBuilder(name: "You", type: .onDevice, team: TeamID(id: 0))
        let teamy = PlayerBuilder(name: "Teamy", type: .computer,  team: TeamID(id: 0))
        
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
