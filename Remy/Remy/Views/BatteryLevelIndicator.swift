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
        ZStack {
            RoundedRectangle(cornerRadius: 9, style: .continuous).fill(ColorManager.spaceGrey).frame(maxWidth: .infinity, maxHeight: 70)
            HStack {
                Text("Battery: ").font(.title3)
                    .multilineTextAlignment(.leading).foregroundColor(.white)
                Spacer()
                HStack {
                    HStack {
                        Text(" \(batteryLevel)%").font(.headline).foregroundColor(.white)
                        batteryIcon.resizable().scaledToFit().frame(width: 30.0).foregroundColor(.white)
                    }
                    if batteryLevel < 20 {
                        Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                    }
                }
            }.padding(.horizontal, 30)
        }
    }
}

struct BatteryLevelIndicator_Previews: PreviewProvider {
    static var previews: some View {
        BatteryLevelIndicator(batteryLevel: 40)
    }
}
