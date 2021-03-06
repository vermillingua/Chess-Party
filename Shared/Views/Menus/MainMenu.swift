//
//  MainMenu.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/23/21.
//

import SwiftUI

struct MainMenu: View {
    @ObservedObject var chessGameStore = ChessGameStore.instance
    
    var body: some View {
        List {
            newGameLinks()
            currentGameLinks()
            finishedGames()
        }
    }
    
    private func newGameLinks() -> some View {
        Section (header: Text("New Game")) {
            newGameLink(forGameType: .duel)
            newGameLink(forGameType: .battle)
            newGameLink(forGameType: .plusWar)
        }
    }
    
    private func currentGameLinks() -> some View {
        let current = chessGameStore.currentGames.filter {!$0.gameState.gameOver}
        return Section (header: Text("Current Games")) {
            ForEach (current) { game in
                currentGameLink(game: game)
            }
        }
    }
    
    private func finishedGames() -> some View {
        let finishedGames = chessGameStore.currentGames.filter {$0.gameState.gameOver}
        if finishedGames.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(Section (header: Text("Finished Games")) {
                ForEach (finishedGames) { game in
                    currentGameLink(game: game)
                }
            })
        }
    }
    
    private func currentGameLink(game: ChessGame) -> some View {
        return NavigationLink(destination: gameView(forGame: game), tag: game.id, selection: self.$chessGameStore.selectedGame) {
            HStack {
                game.gameType.icon
                Text(String(describing: game)).font(Font.body.weight(game.gameState.isWaitingOnUserToMakeMove(game: game) ? .bold : .regular))
                if game.gameState.isWaitingOnComputer(game: game) {
                    Spacer()
                    ProgressView().scaleEffect(0.5).frame(height: 10)
                }
            }
        }

    }
    
    @ViewBuilder
    private func gameView(forGame game: ChessGame) -> some View {
        if game.gameType == .duel {
            DuelGameView(game: game)
        } else if game.gameType == .battle {
           // TODO: Implement
            BattleGameView(game: game)
        } else if game.gameType == .plusWar {
            PlusWarGameView(game: game)
        }
    }
    
    private func newGameLink(forGameType gameType: ChessGameType) -> some View {
        NavigationLink(destination: gameType.gameMaker) {
            HStack {
                gameType.icon.font(.largeTitle)
                VStack (alignment: .leading) {
                    Text(gameType.rawValue).font(.title)
                    Text(gameType.description).font(.caption).lineLimit(3)
                }
            }
        }
    }
}
