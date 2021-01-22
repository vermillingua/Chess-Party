//
//  MainMenu.swift
//  Chess Party (iOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct IOSMainMenu: View {
    let chessGameStore = ChessGameStore.instance
    @State var showSettings = false
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                List {
                    Section (header: Text("New Game")) {
                        newGameLink(forGameType: Duel.self)
                        newGameLink(forGameType: Battle.self)
                    }
                    Section (header: Text("Current Games")) {
                        ForEach (chessGameStore.currentGames) { game in
                            NavigationLink(destination: ChessBoardView(chessGame: game, orientation: .up)) {
                                HStack {
                                    type(of: game.gameType).icon
                                    Text(String(describing: game))
                                }
                            }
                        }
                    }
                }.listStyle(InsetGroupedListStyle())
                HStack {
                    Spacer()
                }
            }
            .navigationBarTitle("Parties")
            .navigationBarItems(trailing: Button(action: { showSettings = true }, label: { Image(systemName: "gear")}))
            .edgesIgnoringSafeArea(.vertical)
        } .sheet(isPresented: $showSettings) {
            NavigationView {
                SettingsView()
                    .navigationBarItems(trailing: Button("Done") { showSettings = false })
                    .navigationTitle("Settings")
            }.edgesIgnoringSafeArea(.all)
        }
    }
    

    func newGameLink(forGameType gameType: ChessGameType.Type) -> some View {
        NavigationLink(destination: gameType.gameMaker()) {
            HStack {
                gameType.icon.font(.largeTitle)
                VStack (alignment: .leading) {
                    Text(gameType.title).font(.title)
                    Text(gameType.description).font(.caption).lineLimit(3)
                }
            }
        }
    }
    
}

