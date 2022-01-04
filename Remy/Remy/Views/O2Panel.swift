//
//  O2Panel.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct O2Panel: View {
    var avgO2Sat: Int
    
    var body: some View {
        ZStack {
            Button(action: {}) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.teal)
                .frame(width: 170, height: 150)
            }
            VStack (alignment: .leading){
                Text("Avg. O2\nSaturation").font(.headline).multilineTextAlignment(.leading).colorInvert()
                Spacer()
                HStack {
                    Text("\(avgO2Sat)%").font(.title).colorInvert()
                    Spacer()
                    Image(systemName: "lungs.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55.0, height: 55.0)
                        .colorInvert()
                }
                .padding(.bottom, 15.0)
            }
            .padding(.all, 14.0)
            .frame(width: 170, height: 150)
            
        }
    }
}

struct O2Panel_Previews: PreviewProvider {
    static var previews: some View {
        O2Panel(avgO2Sat: 98)
    }
}
