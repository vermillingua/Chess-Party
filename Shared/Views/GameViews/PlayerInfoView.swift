//
//  PlayerInfoView.swift
//  Chess Party
//
//  Created by Robert Swanson on 1/24/21.
//

import SwiftUI

struct PlayerInfoView: View {
    let player: Player
    let orientation: LayoutOrientation
    let flip: Bool
    let currentPlayer: Bool
    
    @ViewBuilder
    var body: some View {
        border
    }
    
    var border: some View {
        HStack {
            layout
                .opacity(player.hasBeenEliminated ? 0.80 : 1.0)
                .padding(5)
                .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 4)
                    .opacity(currentPlayer ? 1 : 0))
        }
    }
    
    @ViewBuilder
    var layout: some View {
        if orientation == .vertical{
            if flip {
                verticalLayoutFlipped
            } else {
                verticalLayout
            }
        } else {
            if flip {
                horizontalLayoutFlipped
            } else {
                horizontalLayout
            }
        }
//        .frame(minWidth: 50, minHeight: 50)
//        .background(Color.black)
        
    }
    
    var verticalLayout: some View {
        VStack {
            playerNameLabel
            playerIcon
        }
    }
    
    var verticalLayoutFlipped: some View {
        VStack {
            playerIcon
            playerNameLabel
        }
    }
    
    var horizontalLayout: some View {
        HStack {
            playerNameLabel
            playerIcon
        }
    }
    var horizontalLayoutFlipped: some View {
        HStack {
            playerIcon
            playerNameLabel
        }
    }
    
    var playerIcon: some View {
        player.icon.getImage()
            .font(.body)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 50)
    }
    
    var playerNameLabel: some View {
        Text(player.name).font(.body)
    }
    
    
}
