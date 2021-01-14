//
//  ChessGame.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

class ChessGame: ObservableObject {
    @Published var chessBoard: ChessBoard
    @Published var gameState: GameState
    @Published var selectedPositions: [Position: SelectionType]

    var players: [Player]
    var history: [ChessBoard]
    
    init(chessBoard: ChessBoard, players: [Player]) {
        self.chessBoard = chessBoard
        self.players = players
        history = []
        gameState = .notStarted
        selectedPositions = [:]
    }
    

    // MARK: - View Events
    func userTappedPosition(_ position: Position) {
        selectedPositions = [:]
        if let selection = selectedPositions[position] {
            switch selection {
            case .potentialMove:
                print("Make Move")
                //TODO: Make move
            case .userFocus:
                selectedPositions = [:]
                return
            default:
                selectedPositions = [:]
            }
            print("Deselected")
        }
        selectedPositions[position] = .userFocus
        print("Selected")
        // TODO: Populate potential moves
        
        print(chessBoard.getMoves(from: position))
    }
    
}

