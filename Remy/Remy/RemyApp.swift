//
//  RemyApp.swift
//  Remy
//
//  Created by Jia Chun Xie on 11/18/21.
//

import SwiftUI

@main
struct RemyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                DailyView(saveAction: {})
            }
        }
    }
}
