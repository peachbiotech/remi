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
    
    func loadfromDB() async {
        let url = URL(string: "https://dl.dropbox.com/s/tkxiv4dbstniqld/SampleSleepSession.json?dl=1")!
        let urlSession = URLSession.shared
        do {
            let (data, _) = try await urlSession.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            // grab sessions, SleepSession is instantiated with array of SleepSnapShots
            let session = try decoder.decode([SleepSnapShot].self, from: data)
            let sleepSession = SleepSession(session: session)
            
            let dateKey = Helpers.fetchDateStringFromDate(date: sleepSession.session[sleepSession.session.count-1].time)
            sleepSessions[dateKey] = sleepSession
        }
        catch {
            // Error handling in case the data couldn't be loaded
            // For now, only display the error on the console
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func load(date: Date) async {

        do {
            let dateKey = Helpers.fetchDateStringFromDate(date: date)
            if let data = UserDefaults.standard.object(forKey: dateKey) as? Data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                // grab sessions, SleepSession is instantiated with array of SleepSnapShots
                if let session = try? decoder.decode([SleepSnapShot].self, from: data) {
                    let sleepSession = SleepSession(session: session)
                    sleepSessions[dateKey] = sleepSession
                }
            }
        }
    }
}
