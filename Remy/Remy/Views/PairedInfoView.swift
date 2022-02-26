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
    @Binding var isRecording: Bool
    
    var body: some View {
        VStack {
            if !isRecording {
                Text("Fitcheck 😎")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.bottom], 100)
                    .foregroundColor(.white)
                Text("Wear the tracker snugly against your head").foregroundColor(.white).font(.title2).multilineTextAlignment(.center).padding()
                HStack {
                    Text("Verifying sensors ").foregroundColor(.white).font(.title3)
                    if !bleManager.isReady {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                    else {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    }
                }
            }
            else {
                Text("Setup complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.bottom], 100)
                    .foregroundColor(.white)
                Text("Sweet dreams 🤗").foregroundColor(.white).font(.title2).padding()
            }
            
            Spacer()
            VStack {
                BatteryLevelIndicator(batteryLevel: bleManager.batteryPercentage).foregroundColor(.white).padding(.horizontal)
                EEGQualityIndicator(quality: bleManager.eegQuality).foregroundColor(.white).padding(.horizontal)
                HeartRateQualityIndicator(hasHeart: bleManager.hasHeart, heartRate: bleManager.heartRate).foregroundColor(.white).padding(.horizontal)
                O2QualityIndicator(hasO2: bleManager.hasO2, o2Level: bleManager.o2Level).foregroundColor(.white).padding(.horizontal)
            }
            Spacer()
            if bleManager.isReady && !isRecording{
                Button(action: {isPresentingQuestionnaire = true}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.blue)
                        .frame(width: 170, height: 50)
                        Text("continue").foregroundColor(.white)
                    }
                }
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.midNightBlue)
        .sheet(isPresented: $isPresentingQuestionnaire) {
            NavigationView {
                PreSleepQuestionnaireView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Skip") {
                                isPresentingQuestionnaire = false
                                isRecording = true
                                // spawn background process for collecting data, save survey results
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Continue") {
                                isPresentingQuestionnaire = false
                                isRecording = true
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
        PairedInfoView(bleManager: BLEManager(), isRecording: .constant(false))
    }
}
