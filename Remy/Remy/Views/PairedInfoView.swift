//
//  PairedInfoView.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct PairedInfoView: View {
    
    @ObservedObject var bleManager: BLEManager
    
    @State private var isPresentingQuestionnaire = false
    
    var batteryPercentage: Int {
        switch bleManager.state {
        case .connected:
            return bleManager.batteryPercentage
        default:
            break
        }

        return -1
    }
    
    var eegQuality: EEGQuality {
        switch bleManager.state {
        case .connected:
            return bleManager.eegQuality
        default:
            break
        }

        return EEGQuality.NOSIGNAL
    }
    
    var heartRate: Int{
        switch bleManager.state {
        case .connected:
            return bleManager.heartRate
        default:
            break
        }

        return -1
    }
    
    var o2Level: Int {
        switch bleManager.state {
        case .connected:
            return bleManager.o2Level
        default:
            break
        }

        return -1
    }
    
    var body: some View {

        VStack {
            
            switch bleManager.state {
            case .connected:
                Text(" ").padding()
            default:
                Text("No device connected 🫠").padding()
            }
            
            BatteryLevelIndicator(batteryLevel: batteryPercentage).foregroundColor(.white).padding(.horizontal)
            EEGQualityIndicator(quality: eegQuality).foregroundColor(.white).padding(.horizontal)
            HeartRateQualityIndicator(hasHeart: bleManager.hasHeart, heartRate: heartRate).foregroundColor(.white).padding(.horizontal)
            O2QualityIndicator(hasO2: bleManager.hasO2, o2Level: o2Level).foregroundColor(.white).padding(.horizontal)
            Spacer()
        }
        .navigationTitle("Session")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    isPresentingQuestionnaire = true
                }) {
                    Image(systemName: "note.text")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .sheet(isPresented: $isPresentingQuestionnaire) {
            NavigationView {
                PreSleepQuestionnaireView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingQuestionnaire = false
                                // spawn background process for collecting data, save survey results
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingQuestionnaire = false
                            }
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PairedInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PairedInfoView(bleManager: BLEManager())
    }
}
