//
//  PieceView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct PieceView: View {
    var theme: Theme
    var piece: Piece
    var size: CGSize
    
    var body: some View {
        ZStack {
            theme.getPieceImage(piece).resizable()
        }
        .frame(width: size.width, height: size.height, alignment: .center)
    }
}
