//
//  GameMakerView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct DuelGameMaker: View {
    @State private var playerLocalityIndex = 0
    private var whitePlayer = PlayerBuilder(name: "Player 1", type: .onDevice, team: TeamID(id: 0))
    private var blackPlayer = PlayerBuilder(name: "Player 2", type: .computer, team: TeamID(id: 1))
    
    var body: some View {
        Picker("", selection: $playerLocalityIndex) {
            HStack {
                Label("Single Device", systemImage: "ipad")
            }.tag(0)
            HStack {
                Label("Remote Players", systemImage: "network")
            }.tag(1)
        }
        .frame(idealWidth: 100)
        .pickerStyle(SegmentedPickerStyle())
       
        switch playerLocalityIndex {
        case 0:
            singleDeviceView
        case 1:
            remotePlayersView
        default:
            Text("Error: Unknown player locality")
        }
        Spacer()
    }
    
    var singleDeviceView: some View {
        HStack {
            OnDevicePlayerSelectionView(playerBuilder: whitePlayer, title: "White")
            OnDevicePlayerSelectionView(playerBuilder: blackPlayer, title: "Black")
        }
   }
    
    var remotePlayersView: some View {
        Text("Remote Players")
    }
}
