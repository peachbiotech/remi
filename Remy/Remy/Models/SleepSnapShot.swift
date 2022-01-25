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
    var sleepStage: SleepStageType
    
    init(time: Date, heartRate: Int, o2Sat: Int, sleepStage: SleepStageType) {
        self.time = time
        self.heartRate = heartRate
        self.o2Sat = o2Sat
        self.sleepStage = sleepStage
    }
}
