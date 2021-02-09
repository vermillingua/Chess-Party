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
    static var gameType: ChessGameType { get }
    
    var enPassentPosition: Position? { get set } // MARK: TODO Make this a PlayerID dictionary.

    func getMoves(from position: Position) -> [Move]
    func doMove(_ move: Move) -> ChessBoard
    func isKingInCheck(player: PlayerID) -> Bool
    func canPlayerMakeMove(player: PlayerID) -> Bool
    func getPositionName(_ position: Position) -> String
}

extension ChessBoard {
    func positionInBounds(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < rows && position.column >= 0 && position.column < columns
    }
}
