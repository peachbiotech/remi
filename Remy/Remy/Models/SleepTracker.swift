//
//  SleepTracker.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/18/22.
//

import Foundation

class SleepTracker: ObservableObject {
    @Published var eegQuality: EEGQuality = EEGQuality.GOOD
    @Published var heartRate = 0
    @Published var o2Level = 0
    @Published var batteryLevel: Int = 0
    
    @Published var hasEEG: Bool = false
    @Published var hasHeart: Bool = false
    @Published var hasO2: Bool = false
    @Published var hasBattery: Bool = false
    
    @Published var isReady: Bool = false
    
    
}
