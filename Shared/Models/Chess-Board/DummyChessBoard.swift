//
//  DummyChessBoard.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import Foundation

struct DummyChessBoard: ChessBoard {
    var pieces: [(Position, Piece)]
    var rows: Int
    var columns: Int
    
    init() {
        pieces = []
        rows = 8
        columns = 8
        
        for player in 0..<2 {
            let playerID = PlayerID(id: player)
            let pawnRow = player == 0 ? 1 : 6
            let otherRow = player == 0 ? 0 : 7
            for col in 0..<8 {
                pieces.append((Position(row: pawnRow, col: col), Piece(player: playerID, type: .pawn)))
            }
            pieces.append((Position(row: otherRow, col: 0), Piece(player: playerID, type: .rook)))
            pieces.append((Position(row: otherRow, col: 1), Piece(player: playerID, type: .knight)))
            pieces.append((Position(row: otherRow, col: 2), Piece(player: playerID, type: .bishop)))
            pieces.append((Position(row: otherRow, col: 3), Piece(player: playerID, type: .king)))
            pieces.append((Position(row: otherRow, col: 4), Piece(player: playerID, type: .queen)))
            pieces.append((Position(row: otherRow, col: 5), Piece(player: playerID, type: .bishop)))
            pieces.append((Position(row: otherRow, col: 6), Piece(player: playerID, type: .knight)))
            pieces.append((Position(row: otherRow, col: 7), Piece(player: playerID, type: .rook)))
        }
    }
    
    func getMoves(player: PlayerID) -> [Move] {
        return []
    }
    
    func getMoves(position: Position) -> [Move] {
        return []
    }
    
    mutating func doMove(_ move: Move) {
    }
    
    func isKingInCheck(player: PlayerID) -> Bool {
        return false
    }
    
    
}
