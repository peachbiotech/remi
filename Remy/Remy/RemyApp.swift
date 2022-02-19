//
//  RemyApp.swift
//  Remy
//
//  Created by Jia Chun Xie on 11/18/21.
//

import SwiftUI

@main
struct RemyApp: App {
    @StateObject var bleManager = BLEManager()
    @State private var appState: ApplicationState = ApplicationState()
    @State private var isRecording: Bool = false
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch appState.state {
                case ApplicationStateType.WELCOME:
                    WelcomeView()
                case ApplicationStateType.PAIRING:
                    if bleManager.connectedPeripheral == nil {
                        PairingView(bleManager: bleManager, isRecording: $isRecording)
                    }
                    else {
                        PairedInfoView(bleManager: bleManager, isRecording: $isRecording)
                    }
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
