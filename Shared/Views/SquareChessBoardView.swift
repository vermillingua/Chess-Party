//
//  SquareChessBoardView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct SquareChessBoardView: View {
    var rows: Int
    var cols: Int
    var orientation: Orientation = .up
    
    var theme: Theme
    var board: ChessBoard

    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            boardGrid()
            pieces()
        }
    }
    
    func boardGrid() -> some View {
        VStack (spacing: 0.0) {
            ForEach(0..<rows) { row in
                HStack (spacing: 0.0) {
                    ForEach(0..<cols) { col in
                        TileView(color: getTileColor(atPosition: Position(row: row, col: col))).onTapGesture {
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
                ForEach (0..<board.pieces.count) { pieceIndex in
                    PieceView(theme: theme, piece: board.pieces[pieceIndex].1, size: getPieceSize(withBoardSize: geometry.size))
                        .position(getPiecePosition(withBoardSize: geometry.size, atPosition: board.pieces[pieceIndex].0))
                }
            }
        }.aspectRatio(CGFloat(board.rows)/CGFloat(board.columns), contentMode: .fit)
    }

    func getTileColor(atPosition position: Position) -> Color { (position.row + position.col) % 2 == 0 ? theme.primaryBoardColor : theme.secondaryBoardColor }
    
    func getPieceSize(withBoardSize size: CGSize) -> CGSize { size.divide(widthDividend: board.columns, heightDividend: board.rows) }
    
    func getPiecePosition(withBoardSize size: CGSize, atPosition position: Position) -> CGPoint {
        let tileSize = size.width / CGFloat(board.columns)
        return CGPoint(x: tileSize*(CGFloat(position.col)+0.5), y: tileSize*(CGFloat(position.row)+0.5))
    }
    
    // MARK: - User Intents
    func userTappedTile(at position: Position) {
        print("Tapped Tile At \(position)")
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
