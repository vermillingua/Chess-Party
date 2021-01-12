//
//  Theme.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/11/21.
//

import SwiftUI

protocol Theme {
    var name: String {get}
    var primaryBoardColor: Color {get}
    var secondaryBoardColor: Color {get}

    func getImageFor(piece: Piece) -> Image
}
