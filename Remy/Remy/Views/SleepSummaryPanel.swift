//
//  SleepSummaryPanel.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI

struct SleepSummaryPanel: View {
    var body: some View {
        ZStack {
            Button(action: {}) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.green)
                    .frame(maxWidth: .infinity, maxHeight: 150)
            }
            VStack (alignment: .leading){
                Text("Sleep Goal").font(.headline).multilineTextAlignment(.leading).colorInvert()
                Spacer()
                HStack {
                    Text("8h30m / 8h").font(.title).colorInvert()
                    Spacer()
                    Image(systemName: "bed.double.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50.0, height: 50.0)
                        .colorInvert()
                }
                Text("Congrats! You met your sleep goal!").colorInvert()
                .padding(.bottom, 10.0)
            }
            .padding(.all, 14.0)
            .frame(maxWidth: .infinity, maxHeight: 150)
            
        }
    }
}

struct SleepSummaryPanel_Previews: PreviewProvider {
    static var previews: some View {
        SleepSummaryPanel()
    }
}
