//
//  ContentView.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SquareChessBoardView(rows: 8, cols: 8, theme: ThemeD(), board: DummyChessBoard())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
