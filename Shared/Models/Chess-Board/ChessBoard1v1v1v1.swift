//
//  ChessBoard1v1v1v1.swift
//  Chess Party
//
//  Created by Daniël du Preez on 3/16/21.
//

import Foundation

struct ChessBoard1v1v1v1: TraditionalRulesChessBoard, Codable {
    
    var board: [Position : Piece]
    var kingPosition: [PlayerID : Position]
    var enPassentPositions: [PlayerID : Position]
    var castleableRooks: [PlayerID : Set<Position>]
    var hasKingMoved: [PlayerID : Bool]
    
    static var gameType: ChessGameType = .battle
    
    // Needed for swift to ignore let constants when encoding/decoding
    private enum CodingKeys: String, CodingKey {
        case board, kingPosition, enPassentPositions, castleableRooks, hasKingMoved
    }
    
    let rows: Int = 12
    let columns: Int = 12
    
    let pawnMoveDirection: [PlayerID : Displacement] = [player1: .north, player2: .east, player3: .south, player4: .west]
    
    let pawnDoubleJumpPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 10, column: 2),  Position(row: 10, column: 3),  Position(row: 10, column: 4),  Position(row: 10, column: 5),
                   Position(row: 10, column: 6),  Position(row: 10, column: 7),  Position(row: 10, column: 8),  Position(row: 10, column: 9)],
         player2: [Position(row: 2,  column: 1),  Position(row: 3,  column: 1),  Position(row: 4,  column: 1),  Position(row: 5,  column: 1),
                   Position(row: 6,  column: 1),  Position(row: 7,  column: 1),  Position(row: 8,  column: 1),  Position(row: 9,  column: 1)],
         player3: [Position(row: 1,  column: 2),  Position(row: 1,  column: 3),  Position(row: 1,  column: 4),  Position(row: 1,  column: 5),
                   Position(row: 1,  column: 6),  Position(row: 1,  column: 7),  Position(row: 1,  column: 8),  Position(row: 1,  column: 9)],
         player4: [Position(row: 2,  column: 10), Position(row: 3,  column: 10), Position(row: 4,  column: 10), Position(row: 5,  column: 10),
                   Position(row: 6,  column: 10), Position(row: 7,  column: 10), Position(row: 8,  column: 10), Position(row: 9,  column: 10)]]
    
    let pawnPromotionPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 0,  column: 2),  Position(row: 0,  column: 3),  Position(row: 0,  column: 4),  Position(row: 0,  column: 5),
                   Position(row: 0,  column: 6),  Position(row: 0,  column: 7),  Position(row: 0,  column: 8),  Position(row: 0,  column: 9)],
         player2: [Position(row: 2,  column: 11), Position(row: 3,  column: 11), Position(row: 4,  column: 11), Position(row: 5,  column: 11),
                   Position(row: 6,  column: 11), Position(row: 7,  column: 11), Position(row: 8,  column: 11), Position(row: 9,  column: 11)],
         player3: [Position(row: 11, column: 2),  Position(row: 11, column: 3),  Position(row: 11, column: 4),  Position(row: 11, column: 5),
                   Position(row: 11, column: 6),  Position(row: 11, column: 7),  Position(row: 11, column: 8),  Position(row: 11, column: 9)],
         player4: [Position(row: 2,  column: 0),  Position(row: 3,  column: 0),  Position(row: 4,  column: 0),  Position(row: 5,  column: 0),
                   Position(row: 6,  column: 0),  Position(row: 7,  column: 0),  Position(row: 8,  column: 0),  Position(row: 9,  column: 0)]]
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 11, column: 2)] = Piece(player: player1, type: .rook, team: team1)
        board[Position(row: 11, column: 3)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 11, column: 4)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 11, column: 5)] = Piece(player: player1, type: .queen, team: team1)
        board[Position(row: 11, column: 6)] = Piece(player: player1, type: .king, team: team1)
        board[Position(row: 11, column: 7)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 11, column: 8)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 11, column: 9)] = Piece(player: player1, type: .rook, team: team1)
        
        board[Position(row: 10, column: 2)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 3)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 4)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 5)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 6)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 7)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 8)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 10, column: 9)] = Piece(player: player1, type: .pawn, team: team1)
        
        board[Position(row: 2, column: 0)] = Piece(player: player2, type: .rook, team: team2)
        board[Position(row: 3, column: 0)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 4, column: 0)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 5, column: 0)] = Piece(player: player2, type: .queen, team: team2)
        board[Position(row: 6, column: 0)] = Piece(player: player2, type: .king, team: team2)
        board[Position(row: 7, column: 0)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 8, column: 0)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 9, column: 0)] = Piece(player: player2, type: .rook, team: team2)
        
        board[Position(row: 2, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 3, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 4, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 5, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 6, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 7, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 8, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 9, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        
        board[Position(row: 0, column: 2)] = Piece(player: player3, type: .rook, team: team3)
        board[Position(row: 0, column: 3)] = Piece(player: player3, type: .knight, team: team3)
        board[Position(row: 0, column: 4)] = Piece(player: player3, type: .bishop, team: team3)
        board[Position(row: 0, column: 5)] = Piece(player: player3, type: .queen, team: team3)
        board[Position(row: 0, column: 6)] = Piece(player: player3, type: .king, team: team3)
        board[Position(row: 0, column: 7)] = Piece(player: player3, type: .bishop, team: team3)
        board[Position(row: 0, column: 8)] = Piece(player: player3, type: .knight, team: team3)
        board[Position(row: 0, column: 9)] = Piece(player: player3, type: .rook, team: team3)
        
        board[Position(row: 1, column: 2)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 3)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 4)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 5)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 6)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 7)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 8)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 9)] = Piece(player: player3, type: .pawn, team: team3)
        
        board[Position(row: 2, column: 11)] = Piece(player: player4, type: .rook, team: team4)
        board[Position(row: 3, column: 11)] = Piece(player: player4, type: .knight, team: team4)
        board[Position(row: 4, column: 11)] = Piece(player: player4, type: .bishop, team: team4)
        board[Position(row: 5, column: 11)] = Piece(player: player4, type: .queen, team: team4)
        board[Position(row: 6, column: 11)] = Piece(player: player4, type: .king, team: team4)
        board[Position(row: 7, column: 11)] = Piece(player: player4, type: .bishop, team: team4)
        board[Position(row: 8, column: 11)] = Piece(player: player4, type: .knight, team: team4)
        board[Position(row: 9, column: 11)] = Piece(player: player4, type: .rook, team: team4)
        
        board[Position(row: 2, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 3, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 4, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 5, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 6, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 7, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 8, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 9, column: 10)] = Piece(player: player4, type: .pawn, team: team4)
        
        kingPosition = [PlayerID : Position]()
        kingPosition[player1] = Position(row: 11, column: 6)
        kingPosition[player2] = Position(row: 6, column: 0)
        kingPosition[player3] = Position(row: 0, column: 6)
        kingPosition[player4] = Position(row: 6, column: 11)
        
        hasKingMoved = [PlayerID: Bool]()
        hasKingMoved[player1] = false
        hasKingMoved[player2] = false
        hasKingMoved[player3] = false
        hasKingMoved[player4] = false
        
        castleableRooks = [PlayerID : Set<Position>]()
        castleableRooks[player1] = [Position(row: 11, column: 2), Position(row: 11, column: 9)]
        castleableRooks[player2] = [Position(row: 2, column: 0), Position(row: 9, column: 0)]
        castleableRooks[player3] = [Position(row: 0, column: 2), Position(row: 0, column: 9)]
        castleableRooks[player4] = [Position(row: 2, column: 11), Position(row: 9, column: 11)]
        
        enPassentPositions = [PlayerID : Position]()
    }
    
    func positionInBounds(_ position: Position) -> Bool {
        return (position.row > 1 && position.row < 10 && position.column > -1 && position.column < 12) ||
            (position.row > -1 && position.row < 12 && position.column > 1 && position.column < 10)
    }
    
    //MARK: TODO!!!
    func getPositionName(_ position: Position) -> String {
        "TODO!"
    }
}
