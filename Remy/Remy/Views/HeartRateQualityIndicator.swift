//
//  HeartRateQualityIndicator.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/14/22.
//

import SwiftUI

struct HeartRateQualityIndicator: View {
    var hasHeart: Bool
    var heartRate: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(ColorManager.spaceGrey).frame(maxWidth: .infinity, maxHeight: 70)
            HStack {
                Text("Heart Rate: ").font(.title3)
                    .multilineTextAlignment(.leading).foregroundColor(.white)
                Spacer()
                if hasHeart && heartRate != -1{
                    Text("\(heartRate) bpm").font(.headline).foregroundColor(.white)
                    Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 20.0).foregroundColor(.red)
                }
                else {
                    HStack {
                        Image(systemName: "heart").resizable().scaledToFit().frame(width: 20.0).foregroundColor(.gray)
                        Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                    }
                }
            }.padding(.horizontal, 30)
        }
    }
}

struct HeartRateQualityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateQualityIndicator(hasHeart: true, heartRate: 75)
    }
}
