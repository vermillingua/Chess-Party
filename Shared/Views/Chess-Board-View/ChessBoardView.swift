//
//  SquareChessBoardView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct ChessBoardView: View {
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
                        TileView(selectionType: getDisplayedSelectionType(atPosition: Position(row: row, column: col)),
                                 theme: theme,
                                 tileType: getTileType(atPosition: Position(row: row, column: col)))
                            .onTapGesture {
                                userTappedTile(at: Position(row: row, column: col))
                            }
                    }
                }
            }
        }
    }
    
    func getDisplayedSelectionType(atPosition position: Position) -> ChessGame.SelectionType? {
        if let focused = chessGame.userFocusedPosition, focused == position {
            return .userFocus
        } else if chessGame.potentialMoveDestinations.contains(position) {
            return .potentialMove
        } else if chessGame.warningPositions.contains(position) {
            return .warning
        } else if chessGame.lastMoves.contains(position) {
            return .lastMove
        }
        return nil
    }

    func pieces() -> some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            GeometryReader { geometry in
                ForEach (chessGame.chessPieces) { piece in
                    if let position = piece.position {
                        PieceView(theme: theme, piece: piece,
                                  size: getPieceSize(withBoardSize: geometry.size))
                            .position(getPiecePosition(withBoardSize: geometry.size, atPosition: position))
                            .onTapGesture { userTappedTile(at: position) }
                            .animation(.interactiveSpring())
                    }
                }
            }
        }.aspectRatio(CGFloat(chessGame.chessBoard.rows)/CGFloat(chessGame.chessBoard.columns), contentMode: .fit)
    }
//                ForEach (0..<chessGame.chessBoard.rows) { row in
//                    ForEach (0..<chessGame.chessBoard.columns) { column in
//                        if let piece = chessGame.chessBoard.board[Position(row: row, column: column)] {
//                            PieceView(theme: theme, piece: piece,
//                                      size: getPieceSize(withBoardSize: geometry.size))
//                                .position(getPiecePosition(withBoardSize: geometry.size, atPosition: Position(row: row, column: column)))
//                                .onTapGesture { userTappedTile(at: Position(row: row, column: column)) }
//                        }
//                    }
//            }
//


    func getTileType(atPosition position: Position) -> TileView.TileType {
        (position.row + position.column) % 2 == 0 ? TileView.TileType.primary : TileView.TileType.secondary
    }
    

    func getPieceSize(withBoardSize size: CGSize) -> CGSize { size.divide(widthDividend: chessGame.chessBoard.columns, heightDividend: chessGame.chessBoard.rows) }
    
    func getPiecePosition(withBoardSize size: CGSize, atPosition position: Position) -> CGPoint {
        let tileSize = size.width / CGFloat(chessGame.chessBoard.columns)
        return CGPoint(x: tileSize*(CGFloat(position.column)+0.5), y: tileSize*(CGFloat(position.row)+0.5))
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
