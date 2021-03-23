//
//  MacMainMenu.swift
//  Chess Party (macOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct MacOSNavigationView: View {
    
    @State var showSettings: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Parties").font(.custom("Arial Rounded MT Bold", size: 32)).padding(.bottom, 20)
                MainMenu()
                HStack {
                    Spacer()
                    Button(action: {showSettings = true}, label: { Image(systemName: "gear").font(.headline)}).padding()
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .frame(minWidth: 600, minHeight: 500, idealHeight: nil, alignment: .top)
        .sheet(isPresented: $showSettings) {
            VStack {
                Text("Settings").font(.title)
                SettingsView()
                Button("Done", action: {showSettings = false})
            }.padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        })
    }
    

    // Credit to monyschuk https://developer.apple.com/forums/thread/651807?answerId=617555022#617555022
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}
