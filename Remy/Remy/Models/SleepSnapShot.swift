//
//  SleepSnapShot.swift
//  Remy
//
//  Created by Jia Chun Xie on 1/25/22.
//

import Foundation

struct SleepSnapShot: Codable {
    var time: Date
    var heartRate: Int
    var o2Sat: Int
    var sleepStage: SleepStage
    
    init(time: Date, heartRate: Int, o2Sat: Int, sleepStage: SleepStage) {
        self.time = time
        self.heartRate = heartRate
        self.o2Sat = o2Sat
        self.sleepStage = sleepStage
    }
}
