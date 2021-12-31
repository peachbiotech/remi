//
//  SleepData.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

// A SleepSession contains relevant user-facing sleep data for visualization
struct SleepSession: Identifiable {
    var id: UUID
    var sessionDate: Date     // Date at which sleep session begun
    var avgHeartRate: Int     // BPM
    var avgO2Sat: Int         // Percent O2 Sat.
    var sleepDuration: Int    // Minutes
    var hypnogram: Hypnogram
    
    init(id: UUID = UUID(), sessionDate: Date, avgHeartRate: Int, avgO2Sat: Int, sleepDuration: Int, hypnogram: Hypnogram) {
        self.id = id
        self.sessionDate = sessionDate
        self.avgHeartRate = avgHeartRate
        self.avgO2Sat = avgO2Sat
        self.sleepDuration = sleepDuration
        self.hypnogram = hypnogram
    }
    
    init(id: UUID = UUID(), sessionDate: String, avgHeartRate: Int, avgO2Sat: Int, sleepDuration: Int, hypnogram: Hypnogram) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: sessionDate)
        
        self.id = id
        self.sessionDate = date!
        self.avgHeartRate = avgHeartRate
        self.avgO2Sat = avgO2Sat
        self.sleepDuration = sleepDuration
        self.hypnogram = hypnogram
    }
}

extension SleepSession {

    static let sampleData: [SleepSession] =
    [
        SleepSession(sessionDate: "2021/12/22 22:22", avgHeartRate: 60, avgO2Sat: 98, sleepDuration: 480, hypnogram: Hypnogram.sampleData[0])
    ]
}
