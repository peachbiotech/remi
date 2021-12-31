//
//  EEGStaging.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import Foundation

struct Hypnogram: Identifiable {
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
                stage: .WAKE, begin: 0, end: 10
            ),
            HypnogramSegment(
                stage: .NREM1, begin: 10, end: 20
            ),
            HypnogramSegment(
                stage: .NREM2, begin: 20, end: 30
            ),
            HypnogramSegment(
                stage: .NREM3, begin: 30, end: 40
            ),
            HypnogramSegment(
                stage: .REM, begin: 40, end: 50
            ),
            HypnogramSegment(
                stage: .NREM1, begin: 50, end: 60
            ),
            HypnogramSegment(
                stage: .WAKE, begin: 60, end: 70
            )
        ])
    ]
}
