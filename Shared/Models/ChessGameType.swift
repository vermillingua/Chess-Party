//
//  ChessGameType.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

protocol ChessGameType {
    static var title: String {get}
    static var description: String {get}
    static var icon: Image {get}
    static var gameMaker: () -> AnyView {get}
    static var id: Int {get}
    static var chessBoard: ChessBoard {get}
}

struct Duel: ChessGameType {
    static let title = "Duel"
    static let description = "1v1 chess game following normal rules"
    static let icon = Image(systemName: "person.2")
    static let gameMaker = { return AnyView(OneVOneGameMaker()) }
    static let id = 0
    static let chessBoard: ChessBoard = TraditionalChessBoard()
}

struct Battle: ChessGameType {
    static let title = "Battle"
    static let description = "2v2 chess game on a 8x16 chess board following normal rules"
    static let icon = Image(systemName: "square.and.line.vertical.and.square")
    static let gameMaker = { return AnyView(TwoVTwoGameMaker()) }
    static let id = 1
    static let chessBoard: ChessBoard = TraditionalChessBoard() // TODO: Implement battle chess board
}

