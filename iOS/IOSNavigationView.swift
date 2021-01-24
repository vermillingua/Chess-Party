//
//  MainMenu.swift
//  Chess Party (iOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct IOSNavigationView: View {
    let chessGameStore = ChessGameStore.instance
    @State var showSettings = false
    var body: some View {
        NavigationView {
            MainMenu()
                .navigationBarTitle("Parties")
                .navigationBarItems(trailing: Button(action: { showSettings = true }, label: { Image(systemName: "gear")}))
                .edgesIgnoringSafeArea(.vertical)
                .listStyle(InsetGroupedListStyle())
        } .sheet(isPresented: $showSettings) {
            NavigationView {
                SettingsView()
                    .navigationBarItems(trailing: Button("Done") { showSettings = false })
                    .navigationTitle("Settings")
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

