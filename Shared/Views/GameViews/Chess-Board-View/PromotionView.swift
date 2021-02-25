//
//  PromotionView.swift
//  Chess Party
//
//  Created by Robert Swanson on 2/2/21.
//

import SwiftUI

struct PromotionView: View {
    @EnvironmentObject var settings: AppSettings
    let pieceTypes: [PieceType]
    let pieceSelectionHandler: (PieceType?) -> Void
    let playerID: PlayerID

    var body: some View {
        HStack {
            ForEach (0..<pieceTypes.count) { i in
                settings.theme.pieceImageGetter(pieceTypes[i], playerID)
                    .onTapGesture { pieceSelectionHandler(pieceTypes[i]) }
            }
        }
    }
}

struct PromotionViewModifier: ViewModifier {
    let renderblePiece: RenderablePiece
    let chessGame: ChessGame
    @State var promotionViewIsPresented = true
    
    var pieceTypes: [PieceType]
//    @Binding var pieceIDShowingPromotionView: Int?
    
    func body(content: Content) -> some View {
        content.popover(isPresented: $promotionViewIsPresented) {
            Text("Promotion View")
        }
    }
}

extension View {
    func promotionView(forRenderablePiece piece: RenderablePiece, chessGame: ChessGame, pieceTypes: [PieceType]) -> some View {
        let modifier = PromotionViewModifier(renderblePiece: piece, chessGame: chessGame, pieceTypes: pieceTypes)
        return self.modifier(modifier)
    }
}
