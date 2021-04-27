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
    var horizontalOffsets: CGSize {
        CGSize(width: 100, height: 0)
    }
    var verticalOffsets: CGSize {
        CGSize(width: 0, height: 25)
    }
    var scrollThreshold: CGFloat {
        800
    }
    
    init (game: ChessGame) {
        self.game = game
        self.boardView = ChessBoardView(chessGame: game)
    }
    
    var boardDimensions: CGSize {
        return CGSize(width: game.chessBoard.columns, height: game.chessBoard.rows)
    }
    
    var body: some View {
        GeometryReader { reader in
            if reader.size.reccomendedLayoutOrinetationForShape(boardDimensions: boardDimensions, withHorizontalOffsets: horizontalOffsets, withVerticalOffsets: verticalOffsets) == .vertical {
                verticalLayout(readerSize: reader.size)
            } else {
                horizontalLayout(readerSize: reader.size)
            }
        }.padding()
    }
    
    func verticalLayout(readerSize: CGSize) -> some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        let thirdPlayer = game.players[2]
        let fourthPlayer = game.players[3]
        return
            VStack (alignment: .center, spacing: 0) {
                Spacer()
                HStack {
                    PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                    Spacer()
                    PlayerInfoView(player: fourthPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == fourthPlayer.identity)
                }.frame(height: verticalOffsets.height)
                
                if (readerSize.width < scrollThreshold) {
                    ScrollView(.horizontal) {
                        HStack (alignment: .center, spacing: 0.0){
                            boardView.layoutPriority(1).frame(minWidth: scrollThreshold, maxHeight: scrollThreshold/2)
                        }
                    }
                } else {
                    boardView.layoutPriority(1)
                }
                HStack {
                    PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
                    Spacer()
                    PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == thirdPlayer.identity)
                }.frame(height: verticalOffsets.height)
                Spacer()
            }
        
    }

    func horizontalLayout(readerSize: CGSize) -> some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        let thirdPlayer = game.players[2]
        let fourthPlayer = game.players[3]
        return HStack {
            Spacer()
            VStack {
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == secondPlayer.identity)
                Spacer()
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == firstPlayer.identity)
            }.frame(width: horizontalOffsets.width).padding(Edge.Set.vertical, horizontalOffsets.height/2)
            boardView.layoutPriority(1)
            VStack {
                PlayerInfoView(player: fourthPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == fourthPlayer.identity)
                Spacer()
                PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == thirdPlayer.identity)
            }.frame(width: horizontalOffsets.width).padding(Edge.Set.vertical, horizontalOffsets.height/2)
            Spacer()
        }
        
    }
}


