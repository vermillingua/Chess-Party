//
//  ChessBoard.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

protocol ChessBoard: Codable {
    var board: [Position: Piece] { get }
    var rows: Int { get }
    var columns: Int { get }
    var boardType: ChessBoardType { get }

    func getMoves(from position: Position) -> [Move]
    func doMove(_ move: Move) -> ChessBoard
    func isKingInCheck(player: PlayerID) -> Bool
    func canPlayerMakeMove(player: PlayerID) -> Bool
    func getPositionName(_ position: Position) -> String
    func positionInBounds(_ position: Position) -> Bool
}

enum ChessBoardType: Codable {
    case ChessBoard1v1, ChessBoard2v2, ChessBoard1v1v1v1
}
