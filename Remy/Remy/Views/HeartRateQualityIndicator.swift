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
        HStack {
            Text("Heart Rate: ")
            Spacer()
            if hasHeart {
                Text("\(heartRate) bpm").font(.caption)
                Image(systemName: "heart.fill").foregroundColor(.red)
            }
            else {
                HStack {
                    Image(systemName: "heart").foregroundColor(.gray)
                    Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                }
            }
        }.padding(.horizontal, 80
        )
    }
}

struct HeartRateQualityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateQualityIndicator(hasHeart: true, heartRate: 75)
    }
}
