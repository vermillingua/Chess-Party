//
//  OnDevicePlayerSelectionView.swift
//  Chess Party
//
//  Created by Robert Swanson on 8/12/21.
//

import SwiftUI

struct OnDevicePlayerSelectionView: View {
    @State private var playerBuilder: PlayerBuilder
    private var title: String
    
    init(playerBuilder: PlayerBuilder, title: String) {
        self.playerBuilder = playerBuilder
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title).font(.title)
            Picker("", selection: $playerBuilder.type) {
                HStack { Image(systemName: "person.fill"); Text("Human") }.tag(PlayerType.onDevice)
                HStack { Image(systemName: "desktopcomputer"); Text("Computer") }.tag(PlayerType.computer)
            }
            if (playerBuilder.type == .onDevice) {
                onDeviceDetails
            } else if (playerBuilder.type == .computer) {
                computerDetails
            }
        }
   }
    
    var onDeviceDetails: some View {
        TextField("Name", text: $playerBuilder.name)
    }
    
    @State private var computerDifficulty: Double = 0.50
    var computerDetails: some View {
        Slider(value: $computerDifficulty, in: 1...100)
    }
}
