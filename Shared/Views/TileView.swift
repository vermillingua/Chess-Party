//
//  TileView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct TileView: View {
    var selectionType: SelectionType?
    var theme: Theme
    var tileType: TileType
    
    enum TileType { case primary, secondary }
    
    var body: some View {
        if let selectionType = self.selectionType {
            Rectangle()
                .fill(tileType == .primary ? theme.primaryBoardColor : theme.secondaryBoardColor)
                .aspectRatio(contentMode: .fit)
                .padding(0)
                .border(theme.colorForSelection(selectionType), width: theme.selectionBorderWidth)
        } else {
            Rectangle()
                .fill(tileType == .primary ? theme.primaryBoardColor : theme.secondaryBoardColor)
                .aspectRatio(contentMode: .fit)
                .padding(0)
        }
    }
}

