//
//  Position.swift
//  Chess Party
//
//  Created by Daniël du Preez on 1/8/21.
//

import Foundation

struct Position: Hashable {
    let row: Int
    let col: Int
    
    typealias PositionModifier = (Position) -> Position
    
    func modifyPosition(withFunction modifier: PositionModifier) -> Position{
        return modifier(self)
    }
    
    func modifyPosition(by steps: Int, inDirection direction: Direction) -> Position {
        switch direction {
        case .north: return Position(row: row-steps, col: col)
        case .northEast: return Position(row: row-steps, col: col+steps)
        case .east: return Position(row: row, col: col+steps)
        case .southEast: return Position(row: row+steps, col: col+steps)
        case .south: return Position(row: row+steps, col: col)
        case .southWest: return Position(row: row+steps, col: col-steps)
        case .west: return Position(row: row, col: col-steps)
        case .northWest: return Position(row: row-steps, col: col-steps)
        }
    }
}
