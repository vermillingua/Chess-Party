//
//  CGSizeExtensions.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/27/21.
//

import SwiftUI

enum LayoutOrientation { case vertical, horizontal }

extension CGSize {
    func divide(by dividend: CGFloat) -> CGSize {
        CGSize(width: width/dividend, height: height/dividend)
    }
    
    func divide(widthDividend: Int, heightDividend: Int) -> CGSize {
        CGSize(width: Double(width)/Double(widthDividend), height: Double(height)/Double(heightDividend))
    }
    func multiply(by multipler: CGFloat) -> CGSize {
        CGSize(width: width*multipler, height: height*multipler)
    }
    
    var reccomendedLayoutOrientation: LayoutOrientation {
        (height > width ? .vertical : .horizontal)
    }
}
