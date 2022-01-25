//
//  SleepSummaryPanel.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI

struct SleepSummaryPanel: View {
    var sleepDuration: Int
    var hours: Int {
        sleepDuration / 60
    }
    var minutes: Int {
        if sleepDuration >= 1*60 {
            return sleepDuration % 60
        }
        else {
            return 0
        }
    }
    var summaryMsg: String {
        if sleepDuration > 8*60 {
            return "Congrats! You met your sleep goal!"
        }
        else if sleepDuration < 1*60 {
            return "Insufficient sleep data"
        }
        return ""
    }
    
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
                    Text("\(hours)h\(minutes)m / 8h").font(.title).colorInvert()
                    Spacer()
                    Image(systemName: "bed.double.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50.0, height: 50.0)
                        .colorInvert()
                }
                Text(summaryMsg).colorInvert()
                .padding(.bottom, 10.0)
            }
            .padding(.all, 14.0)
            .frame(maxWidth: .infinity, maxHeight: 150)
            
        }
    }
}

struct SleepSummaryPanel_Previews: PreviewProvider {
    static var previews: some View {
        SleepSummaryPanel(sleepDuration: 500)
    }
}
