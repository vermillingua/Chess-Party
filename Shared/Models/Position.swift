//
//  Position.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Position: Hashable, Identifiable, CustomStringConvertible {
    var row, column: Int
    
    var id: Int {
        return row + 1000 + column //MARK: TODO Something better
    }
    
    func shift(by displacement: Displacement) -> Position {
        Position(row: row + displacement.y, column: column + displacement.x)
    }
    
    var description: String { "(r: \(row), c: \(column))" }
    
    static func getDisplacement(from start: Position, to end: Position) -> Displacement {
        Displacement(x: end.column - start.column, y: end.row - start.row)
    }
    
    static func ==(lhs: Position, rhs: Position) -> Bool { lhs.column == rhs.column && lhs.row == rhs.row}
}

struct Displacement: Equatable {
    static let north = Displacement(x:  0, y:  -1)
    static let south = Displacement(x:  0, y:  1)
    static let east  = Displacement(x:  1, y:  0)
    static let west  = Displacement(x: -1, y:  0)
    static let northeast = north + east
    static let northwest = north + west
    static let southeast = south + east
    static let southwest = south + west
    
    static let allCompassDirections = [north, south, east, west, northeast, northwest, southeast, southwest]
    
    var x, y: Int
    
    var scale: Int { abs(x) + abs(y) }
    
    var normalize: Displacement {
        Displacement(x: sign(x), y: sign(y))
    }
    
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

fileprivate func sign(_ num: Int) -> Int {
    num < 0 ? -1 : (num > 0 ? 1 : 0)
}
