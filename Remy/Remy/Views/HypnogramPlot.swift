//
//  HypnogramPlot.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI
import SimpleChart

struct HypnogramPlot: View {
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    var body: some View {
        let temp: [SCQuadCurveData] = [
            SCQuadCurveData(5.0),
            SCQuadCurveData(4.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(3.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(1.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(2.0),
            SCQuadCurveData(5.0)
        ]
        
        SCQuadCurve(config: SCQuadCurveConfig(chartData: temp, showInterval: false, showXAxis: true, showYAxis: true, stroke: true, color: [.green]))
            .frame(width: 260, height: 150)
    }
}


struct HypnogramPlot_Previews: PreviewProvider {
    static var previews: some View {
        HypnogramPlot()
    }
}
