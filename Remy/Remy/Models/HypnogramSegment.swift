//
//  HypnogramSegment.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct HypnogramSegment: Identifiable, Codable {
    var id: UUID
    var stage: SleepStage
    var begin: Int // Segment start, offset from sleep onset (mins)
    
    init(id: UUID=UUID(), stage: SleepStage, begin: Int) {
        self.id = id
        self.stage = stage
        self.begin = begin
    }
}
