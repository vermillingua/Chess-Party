//
//  SquareChessBoardView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI
import Combine

struct ChessBoardView: View {
    @ObservedObject var chessGame: ChessGame
    @EnvironmentObject var settings: AppSettings
    @State var showingGameOver = false
//    @State var gameStateSink: AnyCancellable?

    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            boardGrid
            selections
            pieces
        }
        .onAppear {
            if chessGame.gameState.gameOver && !chessGame.hasDisplayedGameOver {
                showingGameOver = true
                chessGame.hasDisplayedGameOver = true
            }
//            gameStateSink = chessGame.$gameState.sink { state in
//                if !chessGame.hasDisplayedGameOver && state.gameOver {
//                    showingGameOver = true
//                    chessGame.hasDisplayedGameOver = true
//                }
//            }
        }
        .alert(isPresented: $showingGameOver) {
            var message = ""
            if case ChessGame.GameState.endedVictory(let team) = chessGame.gameState {
                message = "\(chessGame.playersInTeam(team).map {$0.name}.englishDescription) won the game!"
            } else if case ChessGame.GameState.endedStalemate = chessGame.gameState {
                message = "It was a stalemate!"
            }
            return Alert(title: Text("Game Over"), message: Text(message))
        }
    }

    var boardGrid: some View {
        VStack (spacing: 0.0) {
            ForEach(0..<chessGame.chessBoard.rows) { row in
                HStack (spacing: 0.0) {
                    ForEach(0..<chessGame.chessBoard.columns) { col in
                        TileView(tileType: getTileType(atPosition: Position(row: row, column: col)))
//                            .selectView(selectionType: getDisplayedSelectionType(atPosition: Position(row: row, column: col)), theme: settings.theme)
                            .onTapGesture { userTappedTile(at: Position(row: row, column: col)) }
//                            .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    }
                }
            }
        }
    }
    
    var pieces: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach (chessGame.renderedChessPieces) { renderedPiece in
                    if let position = renderedPiece.position {
                        PieceView(piece: renderedPiece.piece,
                                  size: getPieceSize(withBoardSize: geometry.size))
                            .position(getPiecePosition(withBoardSize: geometry.size, atPosition: position))
                            .onTapGesture { userTappedTile(at: position) }
                    }
                }
            }
        }.aspectRatio(CGFloat(chessGame.chessBoard.rows)/CGFloat(chessGame.chessBoard.columns), contentMode: .fit)
    }


    
    var selections: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach(0..<chessGame.chessBoard.rows) { row in
                    ForEach(0..<chessGame.chessBoard.columns) { col in
                        if let selection = getDisplayedSelectionType(atPosition: Position(row: row, column: col)) {
                            selectionView(type: selection, atPosition: Position(row: row, column: col), boardSize: geometry.size)
                        }
                    }
                }
            }
        }.aspectRatio(CGFloat(chessGame.chessBoard.rows)/CGFloat(chessGame.chessBoard.columns), contentMode: .fit)
    }
    
    func selectionView(type: ChessGame.SelectionType, atPosition position: Position, boardSize: CGSize) -> some View {
        let size = getPieceSize(withBoardSize: boardSize)
        let side = min(size.width, size.height) 
        return SelectTileView(selectionType: type, theme: settings.theme)
            .position(getPiecePosition(withBoardSize: boardSize, atPosition: position))
            .frame(width: side, height: side)
            .transition(.opacity)
            .onTapGesture { userTappedTile(at: position) }
        
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

    func getTileType(atPosition position: Position) -> TileView.TileType {
        (position.row + position.column) % 2 == 0 ? TileView.TileType.primary : TileView.TileType.secondary
    }
    

    func getPieceSize(withBoardSize size: CGSize) -> CGSize { size.divide(widthDividend: chessGame.chessBoard.columns, heightDividend: chessGame.chessBoard.rows) }
    
    func getPiecePosition(withBoardSize size: CGSize, atPosition position: Position) -> CGPoint {
        let tileSize = size.width / CGFloat(chessGame.chessBoard.columns)
        return CGPoint(x: tileSize*(CGFloat(position.column)+0.5), y: tileSize*(CGFloat(position.row)+0.5))
    }
    
    // MARK: - Events
    func userTappedTile(at position: Position) {
        chessGame.userTappedPosition(position)
    }
    
    mutating func handleGameOver() {
        self.showingGameOver = true
        self._showingGameOver.wrappedValue = true
        print("showing?", self.showingGameOver)
    }

    enum Orientation {
        case up, down, left, right
    }
}

