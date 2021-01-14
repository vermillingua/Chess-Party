//
//  ContentView.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let player1 = OnDevicePlayer(name: "Dave", playerID: PlayerID(id: 0))
        let player2 = ComputerPlayer(name: "Dave", playerID: PlayerID(id: 1))
        let chessGame = ChessGame(chessBoard: TraditionalChessBoard(), players: [player1, player2])
        SquareChessBoardView(chessGame: chessGame, orientation: .up, theme: ThemeFactory.themeD())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
