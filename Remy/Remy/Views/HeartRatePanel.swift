//
//  HeartRatePanel.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct HeartRatePanel: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.purple)
                .frame(width: 170, height: 150)
            VStack (alignment: .leading){
                Text("Avg. Heart Rate").font(.headline).multilineTextAlignment(.leading).colorInvert()
                Spacer()
                HStack {
                    Text("50 BPM").font(.title).colorInvert()
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
            .frame(width: 170, height: 150)
            
        }
    }
}

struct HeartRatePanel_Previews: PreviewProvider {
    static var previews: some View {
        HeartRatePanel()
    }
}
