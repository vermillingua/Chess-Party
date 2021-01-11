//
//  ContentView.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SquareChessBoardView(rows: 8, cols: 8, primaryColor: Color.gray, secondaryColor: Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
