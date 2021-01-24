//
//  MacMainMenu.swift
//  Chess Party (macOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct MacOSMainMenu: View {
    
    @State var showSettings: Bool = false
    
    var body: some View {
        NavigationView {
            VStack (spacing: 10) {
                Text("Parties").font(.custom("Arial Rounded MT Bold", size: 32)).padding(.bottom, 20)
                List {
                    newGameLinks()
                    currentGameLinks()
                }
                HStack {
                    Spacer()
                    Button(action: {showSettings = true}, label: { Image(systemName: "gear").font(.headline)}).padding()
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(minWidth: 200, minHeight: 400, idealHeight: nil, alignment: .top)
            .toolbar(content: {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }
            })
        }.sheet(isPresented: $showSettings) {
            VStack {
                Text("Settings").font(.title)
                SettingsView().padding(.horizontal)
                Button("Done", action: {showSettings = false})
            }.padding()
        }
    }

    func newGameLinks() -> some View {
        Section (header: Text("New Game")) {
            newGameLink(forGameType: Duel.self)
            newGameLink(forGameType: Battle.self)
        }
    }
    
    func currentGameLinks() -> some View {
        Section (header: Text("Current Games")) {
            ForEach (currentGames) { game in
                NavigationLink(destination: ChessBoardView(chessGame: game, orientation: .up)) {
                    HStack {
                        type(of: game.gameType).icon
                        Text(String(describing: game))
                    }
                }
            }
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
    
    var currentGames: [ChessGame] {
        let white: PlayerID = PlayerID(id: 0)
        let black: PlayerID = PlayerID(id: 1)

        let team1: TeamID = TeamID(id: 0)
        let team2: TeamID = TeamID(id: 1)
        
        return [
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: white, team: team2), ComputerPlayer(name: "Chester", id: black, team: team1)]),
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: white, team: team2), RemotePlayer(name: "Remone", id: black, team: team1)]),
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", id: white, team: team2), RemotePlayer(name: "Teamy", id: white, team: team2), RemotePlayer(name: "Enemenimy", id: black, team: team1), RemotePlayer(name: "Secondenimy", id: white, team: team1)])
        ]
    }
    
    // Credit to monyschuk https://developer.apple.com/forums/thread/651807?answerId=617555022#617555022
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}
