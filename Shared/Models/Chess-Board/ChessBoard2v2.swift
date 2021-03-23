//
//  ChessBoard2v2.swift
//  Chess Party
//
//  Created by Daniël du Preez on 3/2/21.
//

import Foundation

struct ChessBoard2v2: TraditionalRulesChessBoard, Codable {
    
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
    
    let rows: Int = 8
    let columns: Int = 16
    
    let pawnMoveDirection: [PlayerID : Displacement] = [player1: .north, player2: .south, player3: .north, player4: .south]
    
    let pawnDoubleJumpPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 6, column: 0),  Position(row: 6, column: 1),  Position(row: 6, column: 2),  Position(row: 6, column: 3),
                   Position(row: 6, column: 4),  Position(row: 6, column: 5),  Position(row: 6, column: 6),  Position(row: 6, column: 7)],
         player2: [Position(row: 1, column: 0),  Position(row: 1, column: 1),  Position(row: 1, column: 2),  Position(row: 1, column: 3),
                   Position(row: 1, column: 4),  Position(row: 1, column: 5),  Position(row: 1, column: 6),  Position(row: 1, column: 7)],
         player3: [Position(row: 6, column: 8),  Position(row: 6, column: 9),  Position(row: 6, column: 10), Position(row: 6, column: 11),
                   Position(row: 6, column: 12), Position(row: 6, column: 13), Position(row: 6, column: 14), Position(row: 6, column: 15)],
         player4: [Position(row: 1, column: 8),  Position(row: 1, column: 9),  Position(row: 1, column: 10), Position(row: 1, column: 11),
                   Position(row: 1, column: 12), Position(row: 1, column: 13), Position(row: 1, column: 14), Position(row: 1, column: 15)]]
    
    let pawnPromotionPositions: [PlayerID : Set<Position>] =
        [player1: [Position(row: 0, column: 0),  Position(row: 0, column: 1),  Position(row: 0, column: 2),  Position(row: 0, column: 3),
                   Position(row: 0, column: 4),  Position(row: 0, column: 5),  Position(row: 0, column: 6),  Position(row: 0, column: 7)],
         player2: [Position(row: 7, column: 0),  Position(row: 7, column: 1),  Position(row: 7, column: 2),  Position(row: 7, column: 3),
                   Position(row: 7, column: 4),  Position(row: 7, column: 5),  Position(row: 7, column: 6),  Position(row: 7, column: 7)],
         player3: [Position(row: 0, column: 8),  Position(row: 0, column: 9),  Position(row: 0, column: 10), Position(row: 0, column: 11),
                   Position(row: 0, column: 12), Position(row: 0, column: 13), Position(row: 0, column: 14), Position(row: 0, column: 15)],
         player4: [Position(row: 7, column: 8),  Position(row: 7, column: 9),  Position(row: 7, column: 10), Position(row: 7, column: 11),
                   Position(row: 7, column: 12), Position(row: 7, column: 13), Position(row: 7, column: 14), Position(row: 7, column: 15)]]
    
    init() {
        board = [Position: Piece]()
        
        board[Position(row: 7, column: 0)] = Piece(player: player1, type: .rook, team: team1)
        board[Position(row: 7, column: 1)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 7, column: 2)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 7, column: 3)] = Piece(player: player1, type: .queen, team: team1)
        board[Position(row: 7, column: 4)] = Piece(player: player1, type: .king, team: team1)
        board[Position(row: 7, column: 5)] = Piece(player: player1, type: .bishop, team: team1)
        board[Position(row: 7, column: 6)] = Piece(player: player1, type: .knight, team: team1)
        board[Position(row: 7, column: 7)] = Piece(player: player1, type: .rook, team: team1)
        
        board[Position(row: 6, column: 0)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 1)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 2)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 3)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 4)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 5)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 6)] = Piece(player: player1, type: .pawn, team: team1)
        board[Position(row: 6, column: 7)] = Piece(player: player1, type: .pawn, team: team1)
        
        board[Position(row: 0, column: 0)] = Piece(player: player2, type: .rook, team: team2)
        board[Position(row: 0, column: 1)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 0, column: 2)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 0, column: 3)] = Piece(player: player2, type: .queen, team: team2)
        board[Position(row: 0, column: 4)] = Piece(player: player2, type: .king, team: team2)
        board[Position(row: 0, column: 5)] = Piece(player: player2, type: .bishop, team: team2)
        board[Position(row: 0, column: 6)] = Piece(player: player2, type: .knight, team: team2)
        board[Position(row: 0, column: 7)] = Piece(player: player2, type: .rook, team: team2)
        
        board[Position(row: 1, column: 0)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 1)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 2)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 3)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 4)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 5)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 6)] = Piece(player: player2, type: .pawn, team: team2)
        board[Position(row: 1, column: 7)] = Piece(player: player2, type: .pawn, team: team2)
        
        board[Position(row: 7, column: 8)] = Piece(player: player3, type: .rook, team: team1)
        board[Position(row: 7, column: 9)] = Piece(player: player3, type: .knight, team: team1)
        board[Position(row: 7, column: 10)] = Piece(player: player3, type: .bishop, team: team1)
        board[Position(row: 7, column: 11)] = Piece(player: player3, type: .queen, team: team1)
        board[Position(row: 7, column: 12)] = Piece(player: player3, type: .king, team: team1)
        board[Position(row: 7, column: 13)] = Piece(player: player3, type: .bishop, team: team1)
        board[Position(row: 7, column: 14)] = Piece(player: player3, type: .knight, team: team1)
        board[Position(row: 7, column: 15)] = Piece(player: player3, type: .rook, team: team1)
        
        board[Position(row: 6, column: 8)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 9)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 10)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 11)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 12)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 13)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 14)] = Piece(player: player3, type: .pawn, team: team1)
        board[Position(row: 6, column: 15)] = Piece(player: player3, type: .pawn, team: team1)
        
        board[Position(row: 0, column: 8)] = Piece(player: player4, type: .rook, team: team2)
        board[Position(row: 0, column: 9)] = Piece(player: player4, type: .knight, team: team2)
        board[Position(row: 0, column: 10)] = Piece(player: player4, type: .bishop, team: team2)
        board[Position(row: 0, column: 11)] = Piece(player: player4, type: .queen, team: team2)
        board[Position(row: 0, column: 12)] = Piece(player: player4, type: .king, team: team2)
        board[Position(row: 0, column: 13)] = Piece(player: player4, type: .bishop, team: team2)
        board[Position(row: 0, column: 14)] = Piece(player: player4, type: .knight, team: team2)
        board[Position(row: 0, column: 15)] = Piece(player: player4, type: .rook, team: team2)
        
        board[Position(row: 1, column: 8)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 9)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 10)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 11)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 12)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 13)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 14)] = Piece(player: player4, type: .pawn, team: team2)
        board[Position(row: 1, column: 15)] = Piece(player: player4, type: .pawn, team: team2)
        
        kingPosition = [PlayerID : Position]()
        kingPosition[player1] = Position(row: 7, column: 4)
        kingPosition[player2] = Position(row: 0, column: 4)
        kingPosition[player3] = Position(row: 7, column: 12)
        kingPosition[player4] = Position(row: 0, column: 12)
        
        hasKingMoved = [PlayerID: Bool]()
        hasKingMoved[player1] = false
        hasKingMoved[player2] = false
        hasKingMoved[player3] = false
        hasKingMoved[player4] = false
        
        castleableRooks = [PlayerID : Set<Position>]()
        castleableRooks[player1] = [Position(row: 7, column: 7), Position(row: 7, column: 0)]
        castleableRooks[player2] = [Position(row: 0, column: 7), Position(row: 0, column: 0)]
        castleableRooks[player3] = [Position(row: 7, column: 8), Position(row: 7, column: 15)]
        castleableRooks[player4] = [Position(row: 0, column: 8), Position(row: 0, column: 15)]
        
        enPassentPositions = [PlayerID : Position]()
    }
    
    //MARK: TODO!!!
    func getPositionName(_ position: Position) -> String {
        "TODO!"
    }
    
    
}
