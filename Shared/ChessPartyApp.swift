//
//  ChessPartyApp.swift
//  Shared
//
//  Created by Daniël du Preez on 1/6/21.
//

import SwiftUI

@main
struct ChessPartyApp: App {
    private var settings = AppSettings()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            #if os(iOS)
            IOSMainMenu().environmentObject(settings)
            #elseif os(macOS)
            MacOSMainMenu().environmentObject(settings)
            #endif
        }
        #if os(macOS)
        Settings {
            SettingsView().environmentObject(settings)
        }
        #endif
    }
}

