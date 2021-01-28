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

    enum TileType { case primary, secondary }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(tileType == .primary ? settings.theme.primaryBoardColor : settings.theme.secondaryBoardColor)
                .aspectRatio(contentMode: .fit)
                .padding(0)
        }
    }
}


