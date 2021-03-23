//
//  ChessPartyApp.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI
import GameKit

@main
struct ChessPartyApp: App {
    private var settings = AppSettings()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            #if os(iOS)
            IOSNavigationView().environmentObject(settings)
            #elseif os(macOS)
            MacOSNavigationView().environmentObject(settings)
            #endif
        }
        #if os(macOS)
        Settings {
            SettingsView().environmentObject(settings)
        }
        #endif
    }
}

