//
//  PairedInfoView.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct PairedInfoView: View {
    
    @ObservedObject var bleManager: BLEManager
    
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
                if !bleManager.isReady {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }
                else {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
            }
            Spacer()
            VStack {
                BatteryLevelIndicator(batteryLevel: bleManager.batteryLevel).foregroundColor(.white).padding(.vertical, 5)
                EEGQualityIndicator(quality: bleManager.eegQuality).foregroundColor(.white).padding(.vertical, 5)
                HeartRateQualityIndicator(hasHeart: bleManager.hasHeart, heartRate: bleManager.heartRate).foregroundColor(.white).padding(.vertical, 5)
                O2QualityIndicator(hasO2: bleManager.hasO2, o2Level: bleManager.o2Level).foregroundColor(.white).padding(.vertical, 5)
            }
            Spacer()
            
            NavigationLink(destination: PreSleepQuestionnaireView(), tag: 1, selection: $userSelectContinue) {
                if bleManager.isReady {
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
        PairedInfoView(bleManager: BLEManager())
    }
}
