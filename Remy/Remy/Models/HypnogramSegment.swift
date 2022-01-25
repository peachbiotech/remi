//
//  HypnogramSegment.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct HypnogramSegment: Codable {
    var stage: SleepStage
    var begin: Int // Segment start, offset from sleep onset (mins)
    
    init(stage: SleepStage, begin: Int) {
        self.stage = stage
        self.begin = begin
    }
}
