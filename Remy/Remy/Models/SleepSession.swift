//
//  SleepSession.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

// A SleepSession contains relevant user-facing sleep data for visualization
struct SleepSession: Codable {
    var session: [SleepSnapShot]
    
    var hypnogram: Hypnogram {
        get {
            var segments: [HypnogramSegment] = []
            let t0 = session[0].time
            for snapShot in session {
                let dt = SleepSession.timeDifferenceMins(startTime: t0, endTime: snapShot.time)
                let segment = HypnogramSegment(stage: snapShot.sleepStage, begin: dt)
                segments.append(segment)
            }
            return Hypnogram(segments: segments)
        }
    }
    
    var sleepDuration: Int {
        get {
            let startTime = session[0].time
            let endTime = session.last!.time
            return SleepSession.timeDifferenceMins(startTime: startTime, endTime: endTime)
        }
    }
    
    var avgHeartRate: Int {
        get {
            var sum = 0
            for snapShot in session {
                sum += snapShot.heartRate
            }
            return Int(sum / session.count)
        }
    }
    
    var avgO2Sat: Int {
        get {
            var sum = 0
            for snapShot in session {
                sum += snapShot.o2Sat
            }
            return Int(sum / session.count)
        }
    }
    
    private static func timeDifferenceMins(startTime: Date, endTime: Date) -> Int {
        let calendar = Calendar.current
        
        let timeComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        let difference = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        
        return difference
    }
    
    init(time: Date) {
        self.session = [SleepSnapShot(time: time, heartRate: 0, o2Sat: 0, sleepStage: SleepStage.REM),
                        SleepSnapShot(time: time + 1*60, heartRate: 0, o2Sat: 0, sleepStage: SleepStage.REM)]
    }
    
    init(session: [SleepSnapShot]) {
        self.session = session
    }
}
