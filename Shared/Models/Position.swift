//
//  Position.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Vector: Hashable {
    var x, y: Int
    
    static func +(right: Vector, left: Vector) -> Vector {
        return Vector(x: right.x + left.x, y: right.y + left.y)
    }
}
