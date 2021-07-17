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
    
    let boardType: ChessBoardType = .ChessBoard1v1v1v1
    
    // Needed for swift to ignore let constants when encoding/decoding
    private enum CodingKeys: String, CodingKey {
        case board, kingPosition, enPassentPositions, castleableRooks, hasKingMoved
    }
    
    let rows: Int = 14
    let columns: Int = 14
    
    func positionInBounds(_ position: Position) -> Bool {
        return (position.row > 2 && position.row < 11 && position.column > -1 && position.column < 14) ||
            (position.row > -1 && position.row < 14 && position.column > 2 && position.column < 11)
    }
    
    let pawnMoveDirection: [PlayerID : Displacement] = [player1: .north, player2: .east, player3: .south, player4: .west]
    
    let pawnDoubleJumpPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 12, column: 3),
                   Position(row: 12, column: 4),
                   Position(row: 12, column: 5),
                   Position(row: 12, column: 6),
                   Position(row: 12, column: 7),
                   Position(row: 12, column: 8),
                   Position(row: 12, column: 9),
                   Position(row: 12, column: 10)],
         player2: [Position(row: 3,  column: 1),
                   Position(row: 4,  column: 1),
                   Position(row: 5,  column: 1),
                   Position(row: 6,  column: 1),
                   Position(row: 7,  column: 1),
                   Position(row: 8,  column: 1),
                   Position(row: 9,  column: 1),
                   Position(row: 10,  column: 1)],
         player3: [Position(row: 1,  column: 3),
                   Position(row: 1,  column: 4),
                   Position(row: 1,  column: 5),
                   Position(row: 1,  column: 6),
                   Position(row: 1,  column: 7),
                   Position(row: 1,  column: 8),
                   Position(row: 1,  column: 9),
                   Position(row: 1,  column: 10)],
         player4: [Position(row: 3,  column: 12),
                   Position(row: 4,  column: 12),
                   Position(row: 5,  column: 12),
                   Position(row: 6,  column: 12),
                   Position(row: 7,  column: 12),
                   Position(row: 8,  column: 12),
                   Position(row: 9,  column: 12),
                   Position(row: 10,  column: 12)]]
    
    let pawnPromotionPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 0,  column: 10),
                   Position(row: 0,  column: 3),
                   Position(row: 0,  column: 4),
                   Position(row: 0,  column: 5),
                   Position(row: 0,  column: 6),
                   Position(row: 0,  column: 7),
                   Position(row: 0,  column: 8),
                   Position(row: 0,  column: 9)],
         player2: [Position(row: 10,  column: 13),
                   Position(row: 3,  column: 13),
                   Position(row: 4,  column: 13),
                   Position(row: 5,  column: 13),
                   Position(row: 6,  column: 13),
                   Position(row: 7,  column: 13),
                   Position(row: 8,  column: 13),
                   Position(row: 9,  column: 13)],
         player3: [Position(row: 13, column: 10),
                   Position(row: 13, column: 3),
                   Position(row: 13, column: 4),
                   Position(row: 13, column: 5),
                   Position(row: 13, column: 6),
                   Position(row: 13, column: 7),
                   Position(row: 13, column: 8),
                   Position(row: 13, column: 9)],
         player4: [Position(row: 10,  column: 0),
                   Position(row: 3,  column: 0),
                   Position(row: 4,  column: 0),
                   Position(row: 5,  column: 0),
                   Position(row: 6,  column: 0),
                   Position(row: 7,  column: 0),
                   Position(row: 8,  column: 0),
                   Position(row: 9,  column: 0)]]
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 13, column: 2+1)] = Piece(player: player1, type: .rook, team: team1)
        board[Position(row: 13, column: 3+1)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 13, column: 4+1)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 13, column: 5+1)] = Piece(player: player1, type: .queen, team: team1)
        board[Position(row: 13, column: 6+1)] = Piece(player: player1, type: .king, team: team1)
        board[Position(row: 13, column: 7+1)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 13, column: 8+1)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 13, column: 9+1)] = Piece(player: player1, type: .rook, team: team1)
        
        board[Position(row: 12, column: 2+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 3+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 4+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 5+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 6+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 7+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 8+1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 12, column: 9+1)] = Piece(player: player1, type: .pawn, team: team1)
        
        board[Position(row: 2+1, column: 0)] = Piece(player: player2, type: .rook, team: team2)
        board[Position(row: 3+1, column: 0)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 4+1, column: 0)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 5+1, column: 0)] = Piece(player: player2, type: .queen, team: team2)
        board[Position(row: 6+1, column: 0)] = Piece(player: player2, type: .king, team: team2)
        board[Position(row: 7+1, column: 0)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 8+1, column: 0)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 9+1, column: 0)] = Piece(player: player2, type: .rook, team: team2)
        
        board[Position(row: 2+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 3+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 4+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 5+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 6+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 7+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 8+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 9+1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        
        board[Position(row: 0, column: 2+1)] = Piece(player: player3, type: .rook, team: team3)
        board[Position(row: 0, column: 3+1)] = Piece(player: player3, type: .knight, team: team3)
        board[Position(row: 0, column: 4+1)] = Piece(player: player3, type: .bishop, team: team3)
        board[Position(row: 0, column: 5+1)] = Piece(player: player3, type: .queen, team: team3)
        board[Position(row: 0, column: 6+1)] = Piece(player: player3, type: .king, team: team3)
        board[Position(row: 0, column: 7+1)] = Piece(player: player3, type: .bishop, team: team3)
        board[Position(row: 0, column: 8+1)] = Piece(player: player3, type: .knight, team: team3)
        board[Position(row: 0, column: 9+1)] = Piece(player: player3, type: .rook, team: team3)
        
        board[Position(row: 1, column: 2+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 3+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 4+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 5+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 6+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 7+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 8+1)] = Piece(player: player3, type: .pawn, team: team3)
        board[Position(row: 1, column: 9+1)] = Piece(player: player3, type: .pawn, team: team3)
        
        board[Position(row: 2+1, column: 13)] = Piece(player: player4, type: .rook, team: team4)
        board[Position(row: 3+1, column: 13)] = Piece(player: player4, type: .knight, team: team4)
        board[Position(row: 4+1, column: 13)] = Piece(player: player4, type: .bishop, team: team4)
        board[Position(row: 5+1, column: 13)] = Piece(player: player4, type: .queen, team: team4)
        board[Position(row: 6+1, column: 13)] = Piece(player: player4, type: .king, team: team4)
        board[Position(row: 7+1, column: 13)] = Piece(player: player4, type: .bishop, team: team4)
        board[Position(row: 8+1, column: 13)] = Piece(player: player4, type: .knight, team: team4)
        board[Position(row: 9+1, column: 13)] = Piece(player: player4, type: .rook, team: team4)
        
        board[Position(row: 2+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 3+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 4+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 5+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 6+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 7+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 8+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        board[Position(row: 9+1, column: 12)] = Piece(player: player4, type: .pawn, team: team4)
        
        kingPosition = [PlayerID : Position]()
        kingPosition[player1] = Position(row: 13, column: 7)
        kingPosition[player2] = Position(row: 7, column: 0)
        kingPosition[player3] = Position(row: 0, column: 7)
        kingPosition[player4] = Position(row: 7, column: 13)
        
        hasKingMoved = [PlayerID: Bool]()
        hasKingMoved[player1] = false
        hasKingMoved[player2] = false
        hasKingMoved[player3] = false
        hasKingMoved[player4] = false
        
        castleableRooks = [PlayerID : Set<Position>]()
        castleableRooks[player1] = [Position(row: 13, column: 3), Position(row: 13, column: 10)]
        castleableRooks[player2] = [Position(row: 3, column: 0), Position(row: 10, column: 0)]
        castleableRooks[player3] = [Position(row: 0, column: 3), Position(row: 0, column: 10)]
        castleableRooks[player4] = [Position(row: 3, column: 13), Position(row: 10, column: 13)]
        
        enPassentPositions = [PlayerID : Position]()
    }
    
    //MARK: TODO get position name
    func getPositionName(_ position: Position) -> String {
        "TODO!"
    }
}
