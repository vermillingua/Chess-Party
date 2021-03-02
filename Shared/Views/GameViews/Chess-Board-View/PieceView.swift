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
    @State var promotionViewIsPresented = true

    
    var body: some View {
        if let pView = promotionView {
            image.popover(isPresented: $promotionViewIsPresented, content: {pView})
        } else {
            image
        }   
    }
    
    var image: some View {
        settings.theme.pieceImageGetter(renderablePiece.piece.type, renderablePiece.piece.player).resizable()
            .frame(width: size.width, height: size.height, alignment: .center)
    }
}
