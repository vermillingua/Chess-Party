//
//  DuelGameView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/24/21.
//

import SwiftUI

struct PlusWarGameView: View {
    @ObservedObject var game: ChessGame
    var boardView: ChessBoardView
    var horizontalOffsets: CGSize {
        return CGSize(width: 150, height: 20)
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
        layout().padding()
    }
    
    func layout() -> some View {
        let currentPlayer = game.currentPlayer
        let firstPlayer = game.players[0]
        let secondPlayer = game.players[1]
        let thirdPlayer = game.players[2]
        let fourthPlayer = game.players[3]
        
        return VStack {
            PlayerInfoView(player: thirdPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == thirdPlayer.identity).padding(Edge.Set.leading, 5.0)
            HStack {
                PlayerInfoView(player: secondPlayer, orientation: .vertical, flip: true, currentPlayer: currentPlayer?.identity == secondPlayer.identity).padding(Edge.Set.leading, 5.0).frame(minWidth: 75, idealWidth: 100)
                boardView.layoutPriority(1)
                PlayerInfoView(player: fourthPlayer, orientation: .vertical, flip: true, currentPlayer: currentPlayer?.identity == fourthPlayer.identity).padding(Edge.Set.leading, 5.0).frame(minWidth: 75, idealWidth: 100)
            }
            PlayerInfoView(player: firstPlayer, orientation: .horizontal, flip: true, currentPlayer: currentPlayer?.identity == firstPlayer.identity).padding(Edge.Set.leading, 5.0)
        }
    }
}


