//
//  PlayerIcon.swift
//  Chess Party
//
//  Created by Robert Swanson on 6/17/21.
//

import SwiftUI

struct PlayerIcon: Codable {
    let systemString: String
    
    func getImage() -> Image {
        return Image(systemName: systemString)
    }
}
