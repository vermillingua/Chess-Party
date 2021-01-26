//
//  PlayerInfoView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/24/21.
//

import SwiftUI

struct PlayerInfoView: View {
    enum layoutOrientation { case vertical, horizontal }
    var layout: layoutOrientation
    
    var body: some View {
        if layout == .horizontal{
            horizontalLayout()
        } else if layout == .vertical {
            verticalLayout()
        }
    }
    
    func verticalLayout() -> some View {
        return Text("vertical")
    }
    
    func horizontalLayout() -> some View {
        return Text("horizontal")
        
    }
}
