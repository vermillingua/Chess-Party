//
//  DuelGameView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/24/21.
//

import SwiftUI

struct BattleGameView: View {
    @ObservedObject var game: ChessGame
    var boardView: ChessBoardView
    
    init (game: ChessGame) {
        self.game = game
        self.boardView = ChessBoardView(chessGame: game)
    }
    
    var body: some View {
        GeometryReader { reader in
            if reader.size.reccomendedLayoutOrinetationForShape(width: (CGFloat)(game.chessBoard.columns), height: (CGFloat)(game.chessBoard.rows)) == .vertical {
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
        let thirdPlayer = game.players[2]
        let fourthPlayer = game.players[3]
        return HStack {
            Spacer()
            VStack (alignment: .center) {
                Spacer()
                HStack {
                    PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                    Spacer()
                    PlayerInfoView(player: fourthPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == fourthPlayer.identity)
                }
                boardView.layoutPriority(1).background(Color.black)
                HStack {
                    PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
                    Spacer()
                    PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == thirdPlayer.identity)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    var horizontalLayout: some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        let thirdPlayer = game.players[2]
        let fourthPlayer = game.players[3]
        return HStack {
            Spacer()
            VStack {
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                Spacer()
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
            }
            boardView.layoutPriority(1)
            VStack {
                PlayerInfoView(player: fourthPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == fourthPlayer.identity)
                Spacer()
                PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == thirdPlayer.identity)
            }
            Spacer()
        }
        
    }
}


