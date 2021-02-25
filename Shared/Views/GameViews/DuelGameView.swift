//
//  DuelGameView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/24/21.
//

import SwiftUI

struct DuelGameView: View {
    @ObservedObject var game: ChessGame
    var boardView: ChessBoardView
    
    init (game: ChessGame) {
        self.game = game
        self.boardView = ChessBoardView(chessGame: game)
    }
    
    var body: some View {
        GeometryReader { reader in
            if reader.size.reccomendedLayoutOrientation == LayoutOrientation.vertical {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
        .padding()
    }
    
    var verticalLayout: some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        return HStack {
            Spacer()
            VStack (alignment: .center) {
                Spacer()
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                boardView.layoutPriority(1).background(Color.black)
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
                Spacer()
            }
            Spacer()
        }
    }
    
    var horizontalLayout: some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        return HStack {
            Spacer()
            VStack {
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                Spacer()
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
            }
            boardView.layoutPriority(1)
            Spacer()
        }
        
    }
}


