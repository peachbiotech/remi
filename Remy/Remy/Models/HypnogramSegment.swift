//
//  HypnogramSegment.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct HypnogramSegment: Identifiable {
    var id: UUID
    var stage: SleepStage
    var begin: Int // Segment start, offset from sleep onset (mins)
    var end: Int // Segment end
    
    init(id: UUID=UUID(), stage: SleepStage, begin: Int, end: Int) {
        self.id = id
        self.stage = stage
        self.begin = begin
        self.end = end
    }
}
