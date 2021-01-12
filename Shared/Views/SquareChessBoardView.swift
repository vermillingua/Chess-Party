//
//  SquareChessBoardView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct SquareChessBoardView: View {
    @ObservedObject var chessGame: ChessGame
    
    var orientation: Orientation = .up
    var theme: Theme

    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            boardGrid()
            pieces()
        }
    }
    
    func boardGrid() -> some View {
        VStack (spacing: 0.0) {
            ForEach(0..<chessGame.chessBoard.rows) { row in
                HStack (spacing: 0.0) {
                    ForEach(0..<chessGame.chessBoard.columns) { col in
                        TileView(selectionType: chessGame.selectedPositions[Position(row: row, col: col)],
                                 theme: theme,
                                 tileType: getTileType(atPosition: Position(row: row, col: col)))
                            .onTapGesture {
                                userTappedTile(at: Position(row: row, col: col))
                            }
                    }
                }
            }
        }
        
    }
    
    func pieces() -> some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            GeometryReader { geometry in
                ForEach (0..<chessGame.chessBoard.pieces.count) { pieceIndex in
                    PieceView(theme: theme, piece: chessGame.chessBoard.pieces[pieceIndex].1,
                              size: getPieceSize(withBoardSize: geometry.size))
                        .position(getPiecePosition(withBoardSize: geometry.size, atPosition: chessGame.chessBoard.pieces[pieceIndex].0))
                        .onTapGesture {
                            userTappedTile(at: chessGame.chessBoard.pieces[pieceIndex].0)
                        }
                }
            }
        }.aspectRatio(CGFloat(chessGame.chessBoard.rows)/CGFloat(chessGame.chessBoard.columns), contentMode: .fit)
    }
    

    func getTileType(atPosition position: Position) -> TileView.TileType {
        (position.row + position.col) % 2 == 0 ? TileView.TileType.primary : TileView.TileType.secondary
    }
    

    func getPieceSize(withBoardSize size: CGSize) -> CGSize { size.divide(widthDividend: chessGame.chessBoard.columns, heightDividend: chessGame.chessBoard.rows) }
    
    func getPiecePosition(withBoardSize size: CGSize, atPosition position: Position) -> CGPoint {
        let tileSize = size.width / CGFloat(chessGame.chessBoard.columns)
        return CGPoint(x: tileSize*(CGFloat(position.col)+0.5), y: tileSize*(CGFloat(position.row)+0.5))
    }
    
    // MARK: - User Intents
    func userTappedTile(at position: Position) {
        chessGame.userTappedPosition(position)
    }

    enum Orientation {
        case up, down, left, right
    }
}

extension CGSize {
    func divide(by dividend: CGFloat) -> CGSize {
        CGSize(width: width/dividend, height: height/dividend)
    }
    
    func divide(widthDividend: Int, heightDividend: Int) -> CGSize {
        CGSize(width: Double(width)/Double(widthDividend), height: Double(height)/Double(heightDividend))
    }
}
