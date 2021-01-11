//
//  SquareChessBoardView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

struct SquareChessBoardView: View {
    var rows: Int
    var cols: Int
    var primaryColor: Color
    var secondaryColor: Color
    var orientation: Orientation = .up

    var body: some View {
        VStack (spacing: 0.0) {
            ForEach(0..<rows) { row in
                HStack (spacing: 0.0) {
                    ForEach(0..<cols) { col in
                        TileView(color: getTileColor(atPosition: Position(row: row, col: col)))
                    }
                }
            }
        }
    }

    func getTileColor(atPosition position: Position) -> Color { (position.row + position.col) % 2 == 0 ? primaryColor : secondaryColor }

    func getStartingPosition() -> Position {
        switch orientation {
        case .up:
            return Position(row: 0, col: 0)
        case .down:
            return Position(row: rows-1, col: cols-1)
        case .left:
            return Position(row: rows-1, col: 0)
        case .right:
            return Position(row: 0, col: cols-1)
        }
    }
    
    enum Orientation {
        case up, down, left, right
    }
}
