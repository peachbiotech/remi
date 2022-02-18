//
//  BatteryLevelIndicator.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct BatteryLevelIndicator: View {
    
    var batteryLevel: Int
    var batteryIcon: Image {
        if batteryLevel <= 10 {
            return Image(systemName: "battery.0")
        }
        else if batteryLevel <= 25 {
            return Image(systemName: "battery.25")
        }
        else if batteryLevel <= 50 {
            return Image(systemName: "battery.50")
        }
        else if batteryLevel <= 90 {
            return Image(systemName: "battery.75")
        }
        else {
            return Image(systemName: "battery.100")
        }
    }
    
    var body: some View {
        HStack {
            Text("Battery: ")
            Spacer()
            HStack {
                HStack {
                    Text(" \(batteryLevel)%").font(.footnote)
                    batteryIcon
                }
                if batteryLevel < 20 {
                    Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                }
            }
        }.padding(.horizontal, 80)
    }
}

struct BatteryLevelIndicator_Previews: PreviewProvider {
    static var previews: some View {
        BatteryLevelIndicator(batteryLevel: 40)
    }
}
