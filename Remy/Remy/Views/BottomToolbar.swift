//
//  BottomToolbar.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI

struct BottomToolbar: ToolbarContent {
    var body: some ToolbarContent {

        ToolbarItem(placement: .bottomBar) {

            HStack(spacing: 75) {
                VStack {
                    Image(systemName: "bed.double.fill")
                    Text("Summary")
                }

                VStack {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Trends")
                }

                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
        }
    }
}
