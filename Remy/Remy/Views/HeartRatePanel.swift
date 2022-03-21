//
//  HeartRatePanel.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct HeartRatePanel: View {
    var avgHeartRate: Int
    
    var body: some View {
        ZStack {
            Button(action: {}) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorManager.heartRatePanelColor)
                .frame(maxWidth: .infinity, maxHeight: 150)
            }
            VStack (alignment: .leading){
                Text("Avg. Heart Rate").font(.headline).multilineTextAlignment(.leading).foregroundColor(ColorManager.dashboardTextColor)
                Spacer()
                HStack {
                    if avgHeartRate != -1 {
                        Text("\(avgHeartRate) BPM").font(.title).foregroundColor(ColorManager.dashboardTextColor)
                    }
                    else {
                        Text("--  BPM").font(.title).foregroundColor(ColorManager.dashboardTextColor)
                    }
                    Spacer()
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(ColorManager.dashboardTextColor)
                }
                .padding(.bottom, 20.0)
            }
            .padding(.all, 14.0)
            .frame(maxWidth: .infinity, maxHeight: 150)
            
        }
    }
}

struct HeartRatePanel_Previews: PreviewProvider {
    static var previews: some View {
        HeartRatePanel(avgHeartRate: -1)
    }
}
