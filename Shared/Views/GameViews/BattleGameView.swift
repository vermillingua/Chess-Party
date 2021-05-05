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
        return CGSize(width: 150, height: 20)
//        var maxLength = 5
//        for player in boardView.chessGame.players {
//            maxLength = max(maxLength, player.name.count)
//        }
//        maxLength = min(maxLength*8+20+20, 150)
//        print(maxLength)
//        return CGSize(width: maxLength, height: 0)
    }
    var verticalOffsets: CGSize {
        CGSize(width: 0, height: 35)
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
        }
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
                    PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == secondPlayer.identity).padding(Edge.Set.leading, 5.0)
                    Spacer()
                    PlayerInfoView(player: fourthPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == fourthPlayer.identity).padding(Edge.Set.trailing, 5.0)
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
                    PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == firstPlayer.identity).padding(Edge.Set.leading, 5.0)
                    Spacer()
                    PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == thirdPlayer.identity).padding(Edge.Set.trailing, 5.0)
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


