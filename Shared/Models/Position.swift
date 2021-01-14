//
//  Position.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Position: Hashable {
    var row, column: Int
    
    func shift(by displacement: Displacement) -> Position {
        Position(row: row + displacement.x, column: column + displacement.y)
    }
}

struct Displacement {
    static let north = Displacement(x: -1, y:  0)
    static let south = Displacement(x:  1, y:  0)
    static let east  = Displacement(x:  0, y:  1)
    static let west  = Displacement(x:  0, y: -1)
    static let northeast = north + east
    static let northwest = north + west
    static let southeast = south + east
    static let southwest = south + west
    
    static let allCompassDirections = [north, south, east, west, northeast, northwest, southeast, southwest]
    
    var x, y: Int
    
    private var scale: Int { abs(x) + abs(y) }
    
    var rotatedClockwise: Displacement {
        Displacement(x: (x - y) / scale, y: (x + y) / scale)
    }
    
    var rotatedCounterClockwise: Displacement {
        Displacement(x: (x + y) / scale, y: (y - x) / scale)
    }
    
    func scale(by factor: Int) -> Displacement {
        Displacement(x: x * factor, y: y * factor)
    }
    
    static func +(right: Displacement, left: Displacement) -> Displacement {
        Displacement(x: right.x + left.x, y: right.y + left.y)
    }
}
