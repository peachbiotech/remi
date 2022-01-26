//
//  BottomToolbar.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI

struct BottomToolbar: ToolbarContent {
    var body: some ToolbarContent {

        ToolbarItemGroup(placement: .bottomBar) {

            VStack {
                Image(systemName: "bed.double.fill")
                Text("Summary")
            }
            Spacer()
            VStack {
                Image(systemName: "chart.xyaxis.line")
                Text("Trends")
            }
            Spacer()
            VStack {
                Image(systemName: "info.circle")
                Text("About")
            }
        }
    }
}

