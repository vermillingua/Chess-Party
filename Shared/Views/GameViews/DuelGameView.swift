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
    
    var horizontalOffsets: CGSize {
        return CGSize(width: 150, height: 0)
    }
    var verticalOffsets: CGSize {
        CGSize(width: 0, height: 25+10)
    }
    
    var body: some View {
        GeometryReader { reader in
            if reader.size.reccomendedLayoutOrinetationForShape(boardDimensions: CGSize(width: 8, height: 8), withHorizontalOffsets: horizontalOffsets, withVerticalOffsets: verticalOffsets) == LayoutOrientation.vertical {
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
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity).frame(height: verticalOffsets.height)
                boardView.layoutPriority(1).background(Color.black)
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity).frame(height: verticalOffsets.height)
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
                PlayerInfoView(player: secondPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == secondPlayer.identity).frame(width: horizontalOffsets.width)
                Spacer()
                PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: false, currentPlayer: currentPlayer?.identity == firstPlayer.identity).frame(width: horizontalOffsets.width)
            }
            boardView.layoutPriority(1)
            Spacer()
        }
    }
}
