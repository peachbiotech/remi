//
//  HypnogramPlot.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI
import SimpleChart

struct HypnogramPlot: View {
    var hypnogram: Hypnogram
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    func hypnogram2Array(hypnogram: [HypnogramSegment]) -> [SCQuadCurveData] {
        var hypnogramArray: [SCQuadCurveData] = []
        
        for (index, segment) in hypnogram.enumerated() {
            if index == hypnogram.count - 1 {
                break
            }
            var plot_y: Double
            switch segment.stage {
            case .WAKE:
                plot_y = 5.0
            case .NREM1:
                plot_y = 4.0
            case .NREM2:
                plot_y = 3.0
            case .NREM3:
                plot_y = 2.0
            case .REM:
                plot_y = 1.0
            case .END:
                plot_y = 0.0
            }
            let delta_t = hypnogram[index+1].begin - segment.begin
            
            for _ in 0..<(delta_t) {
                hypnogramArray.append(SCQuadCurveData(plot_y))
            }
        }
        
        return hypnogramArray
    }
    
    var body: some View {
        
        SCQuadCurve(config: SCQuadCurveConfig(chartData: hypnogram2Array(hypnogram: hypnogram.segments), showInterval: false, showXAxis: false, showYAxis: true, stroke: true, color: [.green]))
            .frame(width: 260, height: 150)
    }
}
