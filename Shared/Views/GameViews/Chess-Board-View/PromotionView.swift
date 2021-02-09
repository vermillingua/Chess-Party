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
    
    @Binding var pieceTypes: [PieceType]
    @Binding var pieceIDShowingPromotionView: Int?
    
    func body(content: Content) -> some View {
        content.popover(isPresented: promotionViewIsPresented) {
            Text("Promotion View")
        }
    }
    
    private var promotionViewIsPresented: Binding<Bool> {
        Binding(get: { pieceIDShowingPromotionView == renderblePiece.id },
                set: { value in pieceIDShowingPromotionView = (value ? renderblePiece.id : nil) })
    }
}

extension View {
    func promotionView(forRenderablePiece piece: RenderablePiece, chessGame: ChessGame, pieceTypes: Binding<[PieceType]>, pieceIDShowingPromotionView: Binding<Int?>) -> some View {
        let modifer = PromotionViewModifier(renderblePiece: piece, chessGame: chessGame, pieceTypes: pieceTypes, pieceIDShowingPromotionView: pieceIDShowingPromotionView)
        return self.modifier(modifer)
    }
}
