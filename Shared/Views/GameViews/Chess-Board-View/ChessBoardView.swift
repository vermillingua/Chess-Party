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
        }
        .alert(isPresented: $showingGameOver) {
            var message = ""
            if case GameState.endedVictory(let team) = chessGame.gameState {
                message = "\(chessGame.playersInTeam(team).map {$0.name}.englishDescription) won the game!"
            } else if case GameState.endedStalemate = chessGame.gameState {
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
                            .onTapGesture { userTappedTile(at: Position(row: row, column: col)) }
                    }
                }
            }
        }
    }
    
    var pieces: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach (chessGame.renderedChessPieces) { renderedPiece in
                    piece(renderablePiece: renderedPiece, size: geometry.size)
                }
            }
        }.aspectRatio(CGFloat(chessGame.chessBoard.columns)/CGFloat(chessGame.chessBoard.rows), contentMode: .fit)
    }

    func piece(renderablePiece: RenderablePiece, size: CGSize) -> some View {
        var promotionView: PromotionView?
        let pieceSize = getPieceSize(withBoardSize: size)
        
        if let promotionID = chessGame.pieceShowingPromotionView, promotionID == renderablePiece.piece.id {
            promotionView = PromotionView(
                pieceTypes: chessGame.promotionPieceTypes,
                pieceSelectionHandler: {piece in
                    chessGame.handlePromotionSelection(pieceType: piece)
                },
                playerID: renderablePiece.piece.player, pieceSize: pieceSize)
        }
        
        return PieceView(
            renderablePiece: renderablePiece,
            size: pieceSize,
            promotionView: promotionView,
            promotionViewIsPresented: promotionView != nil)
            .position(getPiecePosition(withBoardSize: size, atPosition: renderablePiece.position))
            .onTapGesture { userTappedTile(at: renderablePiece.position) }
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
        }.aspectRatio(CGFloat(chessGame.chessBoard.columns)/CGFloat(chessGame.chessBoard.rows), contentMode: .fit)
    }
    
    func selectionView(type: SelectionType, atPosition position: Position, boardSize: CGSize) -> some View {
        let size = getPieceSize(withBoardSize: boardSize)
        let side = min(size.width, size.height) 
        return SelectTileView(selectionType: type, theme: settings.theme)
            .position(getPiecePosition(withBoardSize: boardSize, atPosition: position))
            .frame(width: side, height: side)
            .transition(.opacity)
            .onTapGesture { userTappedTile(at: position) }
        
    }

    func getDisplayedSelectionType(atPosition position: Position) -> SelectionType? {
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
        if !chessGame.chessBoard.positionInBounds(position) {
            return TileView.TileType.outOfBounds
        }
        else {
            return (position.row + position.column) % 2 == 0 ? TileView.TileType.primary : TileView.TileType.secondary
        }
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

