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
    let pieceSize: CGSize

    var body: some View {
        HStack {
            ForEach (0..<pieceTypes.count) { i in
                settings.theme.pieceImageGetter(pieceTypes[i], playerID).resizable()
                    .frame(width: pieceSize.width*settings.theme.pieceSizePorportion, height: pieceSize.height*settings.theme.pieceSizePorportion, alignment: .center)
                    .onTapGesture {
                        pieceSelectionHandler(pieceTypes[i]) 
                    }
            }
        }
    }
}
