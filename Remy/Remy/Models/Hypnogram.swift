//
//  Hypnogram.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct Hypnogram: Codable {
    var segments: [HypnogramSegment]
    
    init(segments: [HypnogramSegment]) {
        self.segments = segments
    }
}

extension Hypnogram {
    static let sampleData: [Hypnogram] =
    [
        Hypnogram(segments: [
            HypnogramSegment(
                stage: .WAKE, begin: 0
            ),
            HypnogramSegment(
                stage: .WAKE, begin: 60
            ),
            HypnogramSegment(
                stage: .END, begin: 65
            )
        ])
    ]
}
