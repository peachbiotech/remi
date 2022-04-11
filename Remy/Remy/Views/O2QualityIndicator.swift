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
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(ColorManager.spaceGrey).frame(maxWidth: .infinity, maxHeight: 70)
            HStack {
                Text("Oxygen: ").font(.title3)
                    .multilineTextAlignment(.leading).foregroundColor(.white)
                Spacer()
                if hasO2 && o2Level != -1 {
                    HStack {
                        Text("\(o2Level)%").font(.headline).foregroundColor(.white)
                        Image(systemName: "lungs.fill").resizable().scaledToFit().frame(width: 30.0).foregroundColor(.green)
                    }
                }
                else {
                    HStack {
                        Image(systemName: "lungs").resizable().scaledToFit().frame(width: 30.0).foregroundColor(.gray)
                        Image(systemName: "exclamationmark.circle.fill").foregroundColor(.yellow)
                    }
                }
            }.padding(.horizontal, 30)
        }
    }
}

struct O2QualityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        O2QualityIndicator(hasO2: false, o2Level: 98)
    }
}
