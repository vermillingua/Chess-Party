//
//  SettingsView.swift
//  Chess Party (macOS)
//
//  Created by Robert Swanson on 1/19/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: AppSettings
    
    @AppStorage(AppSettings.soundKey) var sounds: Bool = true
    @AppStorage(AppSettings.notificationsKey) var notifications: Bool = true
    @AppStorage(AppSettings.themeKey) var themeSelection: ThemeType = ThemeType.defaultTheme

    var body: some View {
        let form = Form {
            Toggle("Sounds", isOn: $sounds).onChange(of: sounds) { settings.sounds = $0 }
            Toggle("Notifications", isOn: $notifications).onChange(of: notifications) { settings.notifications = $0}
            Button("Reset Games") {
                ChessGameStore.instance.resetGames()
            }
            #if os(macOS)
                Divider()
            #endif
            Picker("Theme", selection: $themeSelection) {
                ForEach(ThemeType.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme.rawValue)
                }
            }.onChange(of: themeSelection) { settings.theme = Theme(themeType: $0)}
        }
        .frame(minWidth: 300, minHeight: 200)
        
        #if os(macOS)
        return form.padding(.horizontal)
        #else
        return form
        #endif
    }
}

class AppSettings: ObservableObject {
    static let soundKey = "sounds"
    static let notificationsKey = "notification"
    static let themeKey = "theme"
    
    @Published var sounds: Bool = UserDefaults.standard.bool(forKey: soundKey)
    @Published var notifications: Bool = UserDefaults.standard.bool(forKey: notificationsKey)
    @Published var theme: Theme = Theme( themeType: ThemeType( rawValue: UserDefaults.standard.string( forKey: themeKey) ?? ThemeType.defaultTheme.rawValue)!)
}
