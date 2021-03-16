//
//  PieceView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct PieceView: View {
    @EnvironmentObject var settings: AppSettings
    var renderablePiece: RenderablePiece
    var size: CGSize
    
    var promotionView: PromotionView?
    @State var promotionViewIsPresented: Bool = true

    init(
        renderablePiece: RenderablePiece,
        size: CGSize,
        promotionView: PromotionView? = nil,
        promotionViewIsPresented: Bool) {
        self.renderablePiece = renderablePiece
        self.size = size
        self.promotionView = promotionView
        self.promotionViewIsPresented = promotionViewIsPresented
    }
    
    var body: some View {
        if let pView = promotionView {
            promotionView(pView)
        } else {
            image
        }   
    }
    
    func promotionView(_ pView: PromotionView) -> AnyView {
        if !promotionViewIsPresented {
            promotionView?.pieceSelectionHandler(nil)
            return AnyView(image.onAppear(perform: {
                promotionViewIsPresented = true
            }))
        }
        return AnyView(image.popover(isPresented: $promotionViewIsPresented, content: {pView}))
    }
    
    var image: some View {
        settings.theme.pieceImageGetter(renderablePiece.piece.type, renderablePiece.piece.player).resizable()
            .frame(width: size.width, height: size.height, alignment: .center)
    }
}
