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
    var imuKey: String = ""
    var eegKey: String = ""
    
    init(time: Date, heartRate: Int, o2Sat: Int, sleepStage: SleepStageType, imuKey: String = "", eegKey: String = "") {
        self.time = time
        self.heartRate = heartRate
        self.o2Sat = o2Sat
        self.sleepStage = sleepStage
        self.imuKey = imuKey
        self.eegKey = eegKey
    }
}
