//
//  DailyView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct DailyView: View {
    
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        .padding(.vertical, 5.0)
                    SleepSummaryPanel()
                        .padding(.bottom, 5.0)
                    HypnogramView(plot: HypnogramPlot())
                        .padding(.bottom, 5.0)
                    HStack {
                        HeartRatePanel()
                        Spacer()
                        O2Panel()
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
        DailyView()
    }
}
