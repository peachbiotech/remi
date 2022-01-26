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
            
            for (i, snapShot) in session.enumerated() {
                let dt = SleepSession.timeDifferenceMins(startTime: t0, endTime: snapShot.time)
                print("\(dt)")
                let segment = HypnogramSegment(stage: snapShot.sleepStage, begin: dt)
                if (i == session.count-1) {
                    assert(snapShot.sleepStage == SleepStageType.END, "Hypnogram should end with END")
                }
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
        let startInMinutes = startTime.timeIntervalSince1970 / 60.0
        let endInMinutes = endTime.timeIntervalSince1970 / 60.0
        print("start: \(startInMinutes)")
        print("end: \(endInMinutes)")
        return Int(endInMinutes - startInMinutes)
    }
    
    init() {
        self.session = [SleepSnapShot(time: Date(), heartRate: 0, o2Sat: 0, sleepStage: SleepStageType.REM),
                        SleepSnapShot(time: Date() + 1*60, heartRate: 0, o2Sat: 0, sleepStage: SleepStageType.REM)]
    }
    
    init(session: [SleepSnapShot]) {
        self.session = session
    }
}
