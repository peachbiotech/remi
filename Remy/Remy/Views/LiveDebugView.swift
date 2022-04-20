//
//  LiveDebugView.swift
//  Remy
//
//  Created by Jia Chun Xie on 4/10/22.
//

import SwiftUI

struct LiveDebugView: View {
    
    @ObservedObject var bleManager: BLEManager
    
    var body: some View {
        VStack {
            Text("Battery: \(bleManager.batteryPercentage)")
            Text("HeartRate: \(bleManager.heartRate)")
            Text("Oxygen: \(bleManager.o2Level)")
            Text("Accelerometer: \(bleManager.accelerometerData.x), \(bleManager.accelerometerData.y),\(bleManager.accelerometerData.z)")
            Text("Gyroscope: \(bleManager.gyroscopeData.x),\(bleManager.gyroscopeData.y),\(bleManager.gyroscopeData.z)")
            Text("EEG: \(bleManager.eeg)")
        }
    }
}

struct LiveDebugView_Previews: PreviewProvider {
    static var previews: some View {
        LiveDebugView(bleManager: BLEManager())
    }
}
