//
//  ComputerPlayer.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import SwiftUI

struct ComputerPlayer: Player {
    let name: String
    let type: PlayerType = .computer
    let identity: PlayerID
    let team: TeamID
    var icon: PlayerIcon
    var hasBeenEliminated: Bool = false
    var nextPlayer: PlayerID
    var lastMove: Move? = nil
    var previousPlayer: PlayerID
    let playerResponseHandler: PlayerResponseHandler?
    
    
    func startMove(withBoard chessBoard: ChessBoard) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            makeArbitraryMove(withBoard: chessBoard)
        }
        
    }
    
    private func makeArbitraryMove(withBoard chessBoard: ChessBoard) {
        for position in chessBoard.board.keys {
            if let piece = chessBoard.board[position], piece.player == identity {
                if let move = chessBoard.getMoves(from: position).first {
                    playerResponseHandler!(move)
                    return
                }
            }
        }
        assert(false, "Couldn't find arbitrary move")
    }
}
