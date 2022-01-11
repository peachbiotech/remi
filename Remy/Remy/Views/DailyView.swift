//
//  DailyView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct DailyView: View {
    
    @State private var date = Date()
    @Binding var sleepSessions: [Date: SleepSession]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        .padding(.vertical, 5.0)
                    SleepSummaryPanel(sleepDuration: sleepSessions[date]!.sleepDuration)
                        .padding(.bottom, 5.0)
                    HypnogramView(hypnogram: sleepSessions[date]!.hypnogram)
                        .padding(.bottom, 5.0)
                    HStack {
                        HeartRatePanel(avgHeartRate: sleepSessions[date]!.avgHeartRate)
                        Spacer()
                        O2Panel(avgO2Sat: sleepSessions[date]!.avgO2Sat)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Sleep Summary")
                .toolbar {
                    BottomToolbar()
                }
            }
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(sleepSessions: .constant([Date(): SleepSession.sampleData[0]]))
    }
}
