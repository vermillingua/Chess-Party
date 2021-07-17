//
//  ChessGameType.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

enum ChessGameType: String, CaseIterable, Codable {
    case duel = "Duel"
    case battle = "Battle"
    case plusWar = "Plus War"
 
    var description: String {
        switch self {
        case .duel:
            return "1v1 chess game"
        case .battle:
            return "2v2 chess game on a 8x16 chess board"
        case .plusWar:
            return "1v1v1v1 chess game on a 12x12 plus board"
        }
    }
    
    var icon: Image {
        switch self {
        case .duel:
            return Image(systemName: "person.2")
        case .battle:
            return Image(systemName: "checkerboard.rectangle")
        case .plusWar:
            return Image(systemName: "plus.viewfinder")
        }
    }
    
    var gameMaker: some View {
        DuelGameMaker()
    }
    
    var isTeamStyle: Bool {
        switch self {
        case .duel:
            return false
        case .battle:
            return true
        case .plusWar:
            return true
        }
    }
    
    var expectedTeamIDs: [TeamID] {
        switch self {
        case .duel:
            return [TeamID(id: 0), TeamID(id: 1)]
        case .battle:
            return [TeamID(id: 0), TeamID(id: 1), TeamID(id: 0), TeamID(id: 1)]
        case .plusWar:
            return [TeamID(id: 0), TeamID(id: 1), TeamID(id: 2), TeamID(id: 3)]
        }
    }
    
    var associatedBoardType: ChessBoardType {
        switch self {
        case .duel:
            return .ChessBoard1v1
        case .battle:
            return .ChessBoard2v2
        case .plusWar:
            return .ChessBoard1v1v1v1
        }
    }
}

