//
//  ContentView.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        #elseif os(macOS)
            MacOSNavigation()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
