//
//  MainMenu.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/23/21.
//

import SwiftUI

struct MainMenu: View {
    let chessGameStore = ChessGameStore.instance
    @State var selectedGame: UUID?
    
    var body: some View {
        List {
            newGameLinks()
            currentGameLinks()
        }
    }
    
    func newGameLinks() -> some View {
        Section (header: Text("New Game")) {
            newGameLink(forGameType: .duel)
            newGameLink(forGameType: .battle)
        }
    }
    
    func currentGameLinks() -> some View {
        Section (header: Text("Current Games")) {
            ForEach (chessGameStore.currentGames) { game in
                NavigationLink(destination: game.gameType.gameView(game: game), tag: game.id, selection: self.$selectedGame) {
                    HStack {
                        game.gameType.icon()
                        Text(String(describing: game)).font(Font.body.weight(game.gameState.isWaitingOnUserToMakeMove() ? .bold : .regular))
                    }
                }
            }.onAppear(perform: {
                selectedGame = chessGameStore.currentGames.first?.id
            })
        }
        
    }
    
    func newGameLink(forGameType gameType: ChessGameType) -> some View {
        NavigationLink(destination: gameType.gameMaker()) {
            HStack {
                gameType.icon().font(.largeTitle)
                VStack (alignment: .leading) {
                    Text(gameType.rawValue).font(.title)
                    Text(gameType.description()).font(.caption).lineLimit(3)
                }
            }
        }
    }
}
