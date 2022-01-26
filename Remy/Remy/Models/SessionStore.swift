//
//  SessionStore.swift
//  Remy
//
//  Created by Jia Chun Xie on 1/8/22.
//

import Foundation
import SwiftUI

@MainActor
class SessionStore: ObservableObject {
    @Published var sleepSessions: [String: SleepSession] = [:]
    
    func load() async {
        let url = URL(string: "https://dl.dropbox.com/s/tkxiv4dbstniqld/SampleSleepSession.json?dl=1")!
        let urlSession = URLSession.shared
        do {
            let (data, _) = try await urlSession.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let session = try decoder.decode([SleepSnapShot].self, from: data)
            let sleepSession = SleepSession(session: session)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: sleepSession.session[0].time)
            let dayKey = String(components.day!)
            
            sleepSessions[dayKey] = sleepSession
        }
        catch {
            // Error handling in case the data couldn't be loaded
            // For now, only display the error on the console
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
}
