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
    
    var reccomendedLayoutOrientationForSquare: LayoutOrientation {
        (height > width ? .vertical : .horizontal)
    }
    
    func reccomendedLayoutOrinetationForShape(boardDimensions: CGSize, withHorizontalOffsets hOffsets: CGSize, withVerticalOffsets vOffsets: CGSize) -> LayoutOrientation {
        let verticalRatio = (self.height - vOffsets.height) / (self.width - vOffsets.width)
        let horizontalRatio = (self.height - hOffsets.height) / (self.width - hOffsets.width)
        let boardRatio = boardDimensions.height / boardDimensions.width
        
        return (abs(verticalRatio-boardRatio) < abs(horizontalRatio-boardRatio)) ? .vertical : .horizontal
        }
        
//        (boardDimensions.height / boardDimensions.width < self.height / (self.width-withHorizontalPlayerinfoWidth) ? .vertical : .horizontal)
    
//    func fitBox(boardDimensions: CGSize, withHorizontalOffsets hOffsets: CGSize, withVerticalOffsets vOffsets: CGSize) -> CGSize {
//        if (reccomendedLayoutOrinetationForShape(boardDimensions: boardDimensions, withHorizontalOffsets: hOffsets, withVerticalOffsets: vOffsets) == .horizontal) {
//            let horizontalRatio = (self.height - hOffsets.height) / (self.width - hOffsets.width)
//            return CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        } else {
//            let verticalRatio = (self.height - vOffsets.height) / (self.width - vOffsets.width)
//
//        }
//    }
    
//    func reccomendedScrolling(boardDimensions: CGSize, withHorizontalOffsets hOffsets: CGSize, withVerticalOffsets vOffsets: CGSize, threshold: CGFloat) -> Bool {
//        let fit = fitBox(size: boardDimensions)
//        return fit.width <= threshold || fit.height <= threshold
//    }
}
