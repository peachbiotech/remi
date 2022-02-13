//
//  RemyApp.swift
//  Remy
//
//  Created by Jia Chun Xie on 11/18/21.
//

import SwiftUI

@main
struct RemyApp: App {
    @State private var appState: ApplicationState = ApplicationState()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch appState.state {
                case ApplicationStateType.WELCOME:
                    WelcomeView()
                case ApplicationStateType.PAIRING:
                    PairingView()
                case ApplicationStateType.DAILY:
                    DailyView(saveAction: {})
                case ApplicationStateType.TRENDS:
                    TrendsView()
                case ApplicationStateType.ABOUT:
                    AboutView()
                }
            }
            .toolbar {
                BottomToolbar(appState: $appState)
            }
        }
    }
}
