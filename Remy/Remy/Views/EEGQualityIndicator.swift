//
//  EEGQualityIndicator.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct EEGQualityIndicator: View {
    var quality: EEGQuality
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(ColorManager.spaceGrey).frame(maxWidth: .infinity, maxHeight: 70)
            HStack {
                Text("EEG:").font(.title3)
                    .multilineTextAlignment(.leading).foregroundColor(.white)
                Spacer()
                switch quality {
                case .NOSIGNAL:
                    HStack {
                        Image(systemName: "waveform").resizable().scaledToFit().frame(width: 20.0).foregroundColor(.gray)
                        Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                    }
                case .OK:
                    Image(systemName: "waveform").resizable().scaledToFit().frame(width: 20.0).foregroundColor(.yellow)
                case .GOOD:
                    Image(systemName: "waveform").resizable().scaledToFit().frame(width: 20.0).foregroundColor(.teal)
                }
            }.padding(.horizontal, 30)
        }
    }
}

struct EEGQualityView: PreviewProvider {
    static var previews: some View {
        EEGQualityIndicator(quality: EEGQuality.NOSIGNAL)
    }
}
