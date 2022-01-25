//
//  DailyView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct DailyView: View {
    
    @State private var date = Date()
    @StateObject var sessionStore = SessionStore()
    let saveAction: ()->Void
    
    var day: String {
        let dateFormatter = DateFormatter()
        print(date)
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: date)
        
        return yearString + "/" + monthString + "/" + dayString
    }
    
    var currentSession: SleepSession {
        get {
            let session: SleepSession = sessionStore.sleepSessions[day] ?? SleepSession(time: Date())
            return session
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                    .padding(.vertical, 5.0)
                SleepSummaryPanel(sleepDuration: currentSession.sleepDuration)
                    .padding(.bottom, 5.0)
                HypnogramView(hypnogram: currentSession.hypnogram)
                    .padding(.bottom, 5.0)
                HStack {
                    HeartRatePanel(avgHeartRate: currentSession.avgHeartRate)
                    Spacer()
                    O2Panel(avgO2Sat: currentSession.avgO2Sat)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Sleep Summary")
            .toolbar {
                BottomToolbar()
            }
        }
        .task {
            await self.sessionStore.load()
        }
        .refreshable {
            await self.sessionStore.load()
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DailyView(saveAction: {})
        }
    }
}
