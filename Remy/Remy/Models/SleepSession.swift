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
                print(snapShot.time)
                print(snapShot.heartRate)
                print(snapShot.o2Sat)
                print(snapShot.sleepStage)
                let dt = SleepSession.timeDifferenceSecs(startTime: t0, endTime: snapShot.time)
                print("\(dt)")
                var segment: HypnogramSegment
                if (i == session.count-1) {
                    segment = HypnogramSegment(stage: SleepStageType.END, begin: dt)
                }
                else {
                    segment = HypnogramSegment(stage: snapShot.sleepStage, begin: dt)
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
            return Int(SleepSession.timeDifferenceSecs(startTime: startTime, endTime: endTime) / 60)
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
    
    private static func timeDifferenceSecs(startTime: Date, endTime: Date) -> Int { // TODO: This is in milisecs not secs
        let startInSecs = startTime.timeIntervalSince1970
        let endInSecs = endTime.timeIntervalSince1970
        print("start: \(startInSecs)")
        print("end: \(endInSecs)")
        return Int(endInSecs - startInSecs)
    }
    
    init() {
        self.session = []
    }
    
    init(session: [SleepSnapShot]) {
        self.session = session
    }
}
