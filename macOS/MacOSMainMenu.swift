//
//  MacMainMenu.swift
//  Chess Party (macOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct MacOSMainMenu: View {
    var body: some View {
        VStack (spacing: 10) {
            Text("Chess Party").font(.custom("Arial Rounded MT Bold", size: 32)).padding(.bottom, 20)
            List {
                Section (header: Text("New Game")) {
                    NavigationLink(destination: GameMakerView()) {
                        Text("1v1").frame(alignment: .center)
                    }
                    NavigationLink(destination: GameMakerView()) {
                        Text("2v2").frame(alignment: .center)
                    }
                }
                Section (header: Text("Current Games")) {
                    ForEach (currentGames) { game in
                        Text(String(describing: game))
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: showSettings, label: { Image(systemName: "gear").font(.system(size: 25))}).padding()
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

    }
    
    func showSettings() {
        
    }
    
    var currentGames: [ChessGame] {
        return [
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), ComputerPlayer(name: "Chester", playerID: PlayerID(id: 1))]),
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), RemotePlayer(name: "Remone", playerID: PlayerID(id: 1))]),
            ChessGame(chessBoard: TraditionalChessBoard(), players: [OnDevicePlayer(name: "You", playerID: PlayerID(id: 0)), RemotePlayer(name: "Teamy", playerID: PlayerID(id: 1)), RemotePlayer(name: "Enemenimy", playerID: PlayerID(id: 2)), RemotePlayer(name: "Secondenimy", playerID: PlayerID(id: 3))])
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
