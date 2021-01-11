//
//  TileView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct TileView: View {
    var color: Color
    
    var body: some View {
        Rectangle().fill(color).aspectRatio(contentMode: .fit).padding(0)
    }
}

