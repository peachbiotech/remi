//
//  HypnogramView.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/30/21.
//

import SwiftUI

struct HypnogramView: View {
    let plot: HypnogramPlot
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black)
                .frame(width: .infinity, height: 220)
            VStack(alignment: .leading) {
                Text("Hypnogram")
                    .font(.headline)
                    .colorInvert()
                HStack {
                    VStack{
                        Text("Awake").padding(3.2).font(.system(size: 12))
                            .colorInvert()
                        Text("NREM1").padding(3.2).font(.system(size: 12))
                            .colorInvert()
                        Text("NREM2").padding(3.2).font(.system(size: 12))
                            .colorInvert()
                        Text("NREM3").padding(3.2).font(.system(size: 12))
                            .colorInvert()
                        Text("REM").padding(3.2).font(.system(size: 12))
                            .colorInvert()
                    }
                    plot
                }
            }.frame(width: .infinity, height: 220)
        }
    }
}

struct HypnogramView_Previews: PreviewProvider {
    static var previews: some View {
        HypnogramView(plot: HypnogramPlot())
    }
}
