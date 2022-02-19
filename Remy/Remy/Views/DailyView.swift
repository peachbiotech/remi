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
    @State private var hasSession = false
    @State private var currentSession = SleepSession()
    let saveAction: ()->Void
    
    var day: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return String(components.day!)
    }
    
    private func retrieveSession() {
        print("retrieving session")
        let session: SleepSession? = sessionStore.sleepSessions[day] ?? nil
        if (session == nil) {
            print("no sessions found")
            hasSession = false
        }
        else {
            print("found session")
            hasSession = true
        }
        currentSession = session ?? SleepSession()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                    .padding(.vertical, 5.0)
                    .onChange(of: date, perform: { value in
                        Task {
                            await self.sessionStore.load()
                        }
                        retrieveSession()
                    })
                if hasSession {
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
                else {
                    Text("No sleep data available for current date" + " 😪").padding(.top, 50.0)
                }
            }
            .padding()
            .navigationTitle("Sleep Summary")
        }
        .task {
            await self.sessionStore.load()
            retrieveSession()
        }
        .refreshable {
            await self.sessionStore.load()
            retrieveSession()
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
