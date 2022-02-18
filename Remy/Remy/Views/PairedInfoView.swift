//
//  PairedInfoView.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct PairedInfoView: View {
    
    var batteryLevel = 65
    var hasBattery: Bool {
        if batteryLevel > 20 {
            return true
        }
        else {
            return false
        }
    }
    var eegQuality: EEGQuality = EEGQuality.GOOD
    var hasEEG: Bool {
        switch eegQuality {
        case .NOSIGNAL:
            return false
        case .OK:
            return false
        case .GOOD:
            return true
        }
    }
    var heartRate: Int = 60
    var hasHeart: Bool = true
    var o2Level: Int = 98
    var hasO2: Bool = true
    
    var checksComplete: Bool {
        if (hasEEG && hasHeart && hasO2 && hasBattery) {
            return true
        }
        else {
            return false
        }
    }
    
    @State var userSelectContinue: Int? = nil
    
    var body: some View {
        VStack {
            Text("Fitcheck")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.bottom], 100)
                .foregroundColor(.white)
            Text("Wear the tracker snugly against your head").foregroundColor(.white).font(.headline).padding()
            HStack {
                Text("Verifying sensors").foregroundColor(.white).font(.headline)
                if !checksComplete {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }
                else {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
            }
            Spacer()
            VStack {
                BatteryLevelIndicator(batteryLevel: batteryLevel).foregroundColor(.white).padding(.vertical, 5)
                EEGQualityIndicator(quality: eegQuality).foregroundColor(.white).padding(.vertical, 5)
                HeartRateQualityIndicator(hasHeart: hasHeart, heartRate: heartRate).foregroundColor(.white).padding(.vertical, 5)
                O2QualityIndicator(hasO2: hasO2, o2Level: o2Level).foregroundColor(.white).padding(.vertical, 5)
            }
            Spacer()
            
            NavigationLink(destination: PreSleepQuestionnaireView(), tag: 1, selection: $userSelectContinue) {
                if checksComplete {
                    Button(action: {userSelectContinue = 1}) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.blue)
                            .frame(width: 170, height: 50)
                            Text("continue").foregroundColor(.white)
                        }
                    }
                }
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.midNightBlue)
        
    }
}

struct PairedInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PairedInfoView()
    }
}
