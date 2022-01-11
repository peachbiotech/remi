//
//  RemyApp.swift
//  Remy
//
//  Created by Jia Chun Xie on 11/18/21.
//

import SwiftUI

@main
struct RemyApp: App {
    @StateObject private var store = SessionStore()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DailyView(sleepSessions: $store.sleepSessions) {
                Task {
                    do {
                        try await SessionStore.save(sleepSessions: store.sleepSessions)
                    } catch {
                        fatalError("Error saving sessions")
                    }
                }
            }
        }
    }
}
