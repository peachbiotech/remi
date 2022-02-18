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
        HStack {
            Text("EEG:")
            Spacer()
            switch quality {
            case .NOSIGNAL:
                HStack {
                    Image(systemName: "waveform").foregroundColor(.gray)
                    Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                }
            case .OK:
                Image(systemName: "waveform").foregroundColor(.yellow)
            case .GOOD:
                Image(systemName: "waveform").foregroundColor(.teal)
            }
        }.padding(.horizontal, 80)
    }
}

struct EEGQualityView: PreviewProvider {
    static var previews: some View {
        EEGQualityIndicator(quality: EEGQuality.NOSIGNAL)
    }
}
