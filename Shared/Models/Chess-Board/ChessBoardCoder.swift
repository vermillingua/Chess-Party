//
//  ChessBoardCoder.swift
//  Chess Party
//
//  Created by Robert Swanson on 6/29/21.
//

import Foundation

struct ChessBoardCoder {
    static func encodeKeyed<Keys: CodingKey>(container: inout KeyedEncodingContainer<Keys>, key: Keys, board: ChessBoard) throws {
        switch board.boardType {
        case .ChessBoard1v1:
            try container.encode(board as! ChessBoard1v1, forKey: key)
        case .ChessBoard2v2:
            try container.encode(board as! ChessBoard2v2, forKey: key)
        case .ChessBoard1v1v1v1:
            try container.encode(board as! ChessBoard1v1v1v1, forKey: key)
        }
    }
    
    private static func encodeUnkeyed(container: inout UnkeyedEncodingContainer, board: ChessBoard) throws {
        switch board.boardType {
        case .ChessBoard1v1:
            try container.encode(board as! ChessBoard1v1)
        case .ChessBoard2v2:
            try container.encode(board as! ChessBoard2v2)
        case .ChessBoard1v1v1v1:
            try container.encode(board as! ChessBoard1v1v1v1)
        }
    }
    
    static func encodeChessBoardList(container: inout UnkeyedEncodingContainer, boards: [ChessBoard]) throws {
        try boards.forEach{ board in
            try encodeUnkeyed(container: &container, board: board)
        }
    }
    
    static func decodeKeyed<Keys: CodingKey>(container: KeyedDecodingContainer<Keys>, key: Keys, gameType: ChessGameType) throws -> ChessBoard {
        switch gameType.associatedBoardType {
        case .ChessBoard1v1:
            return try container.decode(ChessBoard1v1.self, forKey: key)
        case .ChessBoard2v2:
            return try container.decode(ChessBoard2v2.self, forKey: key)
        case .ChessBoard1v1v1v1:
            return try container.decode(ChessBoard1v1v1v1.self, forKey: key)
        }
    }
    
    private static func decodeUnkeyed(container: inout UnkeyedDecodingContainer, gameType: ChessGameType) throws -> ChessBoard {
        switch gameType.associatedBoardType {
        case .ChessBoard1v1:
            return try container.decode(ChessBoard1v1.self)
        case .ChessBoard2v2:
            return try container.decode(ChessBoard2v2.self)
        case .ChessBoard1v1v1v1:
            return try container.decode(ChessBoard1v1v1v1.self)
        }
    }
    
    static func decodeChessBoardList(container: inout UnkeyedDecodingContainer, gameType: ChessGameType) throws -> [ChessBoard] {
        var boards: [ChessBoard] = []
        while !container.isAtEnd {
            try boards.append(decodeUnkeyed(container: &container, gameType: gameType))
        }
        return boards
    }
}
