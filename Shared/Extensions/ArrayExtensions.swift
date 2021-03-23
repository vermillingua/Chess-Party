//
//  ListExtensions.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/29/21.
//

import Foundation

extension Array {
    var englishDescription: String {
        var english = ""
        for i in 0..<count{
            if i > 0 && count > 2 {
                if i == count-1 {
                    english += ", and "
                    
                } else {
                    english += ", "
                }
            } else if i == 1 && count == 2 {
                english += " and "
            }
            english += String(describing: self[i])
        }
        return english
    }
}
