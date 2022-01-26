//
//  HypnogramView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct HypnogramView: View {
    var hypnogram: Hypnogram
    
    var body: some View {
        ZStack {
            Button(action: {}) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorManager.hypnogramPanelColor)
                .frame(maxWidth: .infinity, maxHeight: 220)
            }
            VStack(alignment: .leading) {
                Text("Hypnogram")
                    .font(.headline)
                    .foregroundColor(ColorManager.dashboardTextColor)
                HStack {
                    VStack(alignment: .leading){
                        Text("Awake").padding(3.2).font(.system(size: 12))
                            .foregroundColor(ColorManager.dashboardTextColor)
                        Text("NREM1").padding(3.2).font(.system(size: 12))
                            .foregroundColor(ColorManager.dashboardTextColor)
                        Text("NREM2").padding(3.2).font(.system(size: 12))
                            .foregroundColor(ColorManager.dashboardTextColor)
                        Text("NREM3").padding(3.2).font(.system(size: 12))
                            .foregroundColor(ColorManager.dashboardTextColor)
                        Text("REM").padding(3.2).font(.system(size: 12))
                            .foregroundColor(ColorManager.dashboardTextColor)
                    }
                    Spacer()
                    HypnogramPlot(hypnogram: hypnogram)
                }
            }.padding()
            .frame(maxWidth: .infinity, maxHeight: 220)
        }
    }
}

