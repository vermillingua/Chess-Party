//
//  ChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

protocol ChessBoard {
    var board: [Position: Piece] { get }
    var rows: Int { get }
    var columns: Int { get }
    
    func getMoves(for piece: Piece) -> [Move]
    func isKingInCheck(player: PlayerID) -> Bool
    func getPositionName(_ position: Position) -> String
}
