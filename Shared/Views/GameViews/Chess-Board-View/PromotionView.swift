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
