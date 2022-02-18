//
//  O2QualityIndicator.swift
//  Remy
//
//  Created by Jia Chun Xie on 2/15/22.
//
import SwiftUI

struct O2QualityIndicator: View {
    var hasO2: Bool
    var o2Level: Int
    
    var body: some View {
        HStack {
            Text("Oxygen: ")
            Spacer()
            if hasO2 {
                HStack {
                    Text("\(o2Level)%").font(.caption)
                    Image(systemName: "lungs.fill").foregroundColor(.green)
                }
            }
            else {
                HStack {
                    Image(systemName: "lungs").foregroundColor(.gray)
                    Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                }
            }
        }.padding(.horizontal, 80)
    }
}

struct O2QualityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        O2QualityIndicator(hasO2: false, o2Level: 98)
    }
}
