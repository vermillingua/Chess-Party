//
//  PieceView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct PieceView: View {
    @EnvironmentObject var settings: AppSettings
    var piece: Piece
    var size: CGSize
    
    var body: some View {
        settings.theme.pieceImageGetter(piece).resizable()
        .frame(width: size.width, height: size.height, alignment: .center)
    }
}
