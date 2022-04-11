//
//  RemyApp.swift
//  Remy
//
//  Created by Jia Chun Xie on 11/18/21.
//

import SwiftUI

@main
struct RemyApp: App {
    
    init() {
        _sessionStore = StateObject(wrappedValue: SessionStore())
        _bleManager = StateObject(wrappedValue: BLEManager())
    }
    
    @StateObject var sessionStore: SessionStore
    @StateObject var bleManager: BLEManager
    @State private var appState: ApplicationState = ApplicationState()
    @State private var isRecording: Bool = false
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch appState.state {
                case ApplicationStateType.WELCOME:
                    WelcomeView()
                case ApplicationStateType.VIEWCURRENT:
                    PairedInfoView(bleManager: bleManager)
                case ApplicationStateType.DAILY:
                    DailyView(sessionStore: sessionStore, saveAction: {})
                case ApplicationStateType.TRENDS:
                    TrendsView()
                case ApplicationStateType.ABOUT:
                    AboutView(bleManager: bleManager)
                }
            }
            .toolbar {
                BottomToolbar(appState: $appState)
            }
        }
    }
}
