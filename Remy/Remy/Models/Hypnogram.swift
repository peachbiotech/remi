//
//  Hypnogram.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct Hypnogram: Identifiable, Codable {
    var id: UUID
    var segments: [HypnogramSegment]
    
    init(id: UUID = UUID(), segments: [HypnogramSegment]) {
        self.id = id
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
                stage: .NREM1, begin: 10
            ),
            HypnogramSegment(
                stage: .NREM2, begin: 20
            ),
            HypnogramSegment(
                stage: .NREM3, begin: 30
            ),
            HypnogramSegment(
                stage: .REM, begin: 40
            ),
            HypnogramSegment(
                stage: .NREM1, begin: 50
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
