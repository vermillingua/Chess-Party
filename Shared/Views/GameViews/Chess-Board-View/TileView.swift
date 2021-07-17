//
//  TileView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct TileView: View {
    @EnvironmentObject var settings: AppSettings
    
    var tileType: TileType

    enum TileType { case primary, secondary, outOfBounds }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(tileType == .primary ? settings.theme.primaryBoardColor : settings.theme.secondaryBoardColor)
                .opacity(tileType == .outOfBounds ? 0.0 : 1.0)
                .aspectRatio(contentMode: .fit)
                .padding(0)
        }
    }
}


