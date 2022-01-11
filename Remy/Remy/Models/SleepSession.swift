//
//  SleepData.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

// A SleepSession contains relevant user-facing sleep data for visualization
struct SleepSession: Identifiable, Codable {
    var id: UUID
    var sessionDate: Date     // Date at which sleep session begun
    var heartRates: [Int: Int] // Store heart rates and O2 saturation in dict
    var o2Sats: [Int: Int]     // Key: Offset from start in minutes
    var sleepDuration: Int    // Minutes
    var hypnogram: Hypnogram
    
    var avgHeartRate: Int {
        get {
            var sum = 0
            for (_, heartRate) in heartRates {
                sum += heartRate
            }
            return Int(sum / heartRates.count)
        }
    }
    
    var avgO2Sat: Int {
        get {
            var sum = 0
            for (_, o2Sat) in o2Sats {
                sum += o2Sat
            }
            return Int(sum / o2Sats.count)
        }
    }
    
    init(id: UUID = UUID(), sessionDate: Date, heartRates: [Int: Int], o2Sats: [Int: Int], sleepDuration: Int, hypnogram: Hypnogram) {
        self.id = id
        self.sessionDate = sessionDate
        self.heartRates = heartRates
        self.o2Sats = o2Sats
        self.sleepDuration = sleepDuration
        self.hypnogram = hypnogram
    }
    
    init(id: UUID = UUID(), sessionDate: String, heartRates: [Int: Int], o2Sats: [Int: Int],  sleepDuration: Int, hypnogram: Hypnogram) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: sessionDate)
        
        self.id = id
        self.sessionDate = date!
        self.heartRates = heartRates
        self.o2Sats = o2Sats
        self.sleepDuration = sleepDuration
        self.hypnogram = hypnogram
    }
}

extension SleepSession {

    static let sampleData: [SleepSession] =
    [
        SleepSession(sessionDate: "2021/12/22 22:22", heartRates: [0:60], o2Sats: [0:98], sleepDuration: 500, hypnogram: Hypnogram.sampleData[0])
    ]
}
