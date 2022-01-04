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
                    .fill(Color.purple)
                .frame(maxWidth: .infinity, maxHeight: 150)
            }
            VStack (alignment: .leading){
                Text("Avg. Heart Rate").font(.headline).multilineTextAlignment(.leading).colorInvert()
                Spacer()
                HStack {
                    Text("\(avgHeartRate) BPM").font(.title).colorInvert()
                    Spacer()
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50.0, height: 50.0)
                        .colorInvert()
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
        HeartRatePanel(avgHeartRate: 50)
    }
}
