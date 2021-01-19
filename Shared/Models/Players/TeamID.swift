//
//  Team.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/9/21.
//

import Foundation

struct TeamID: Identifiable {
    var id: Int
    
    static func ==(lhs: TeamID, rhs: TeamID) -> Bool {
        return lhs.id == rhs.id
    }
}
