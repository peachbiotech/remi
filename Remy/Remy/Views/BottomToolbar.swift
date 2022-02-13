//
//  BottomToolbar.swift
//  Remy
//
//  Created by Jia Chun Xie on 12/31/21.
//

import SwiftUI

struct BottomToolbar: ToolbarContent {
    @Binding var appState: ApplicationState
    
    func getButtonColor(button: String) -> Color {
        switch appState.state {
            case ApplicationStateType.DAILY:
                if button == "Daily" {
                    return ColorManager.bottomToolbarTextColor
                } else {
                    return ColorManager.bottomToolbarTextInactiveColor
                }
            
            case ApplicationStateType.TRENDS:
                if button == "Trends" {
                    return ColorManager.bottomToolbarTextColor
                } else {
                    return ColorManager.bottomToolbarTextInactiveColor
                }
            
            case ApplicationStateType.PAIRING:
                if button == "Pairing" {
                    return ColorManager.bottomToolbarTextColor
                } else {
                    return ColorManager.bottomToolbarTextInactiveColor
                }
            
            case ApplicationStateType.ABOUT:
                if button == "About" {
                    return ColorManager.bottomToolbarTextColor
                } else {
                    return ColorManager.bottomToolbarTextInactiveColor
                }
        case .WELCOME:
            return ColorManager.bottomToolbarTextInactiveColor
        }
    }
    
    var body: some ToolbarContent {

        ToolbarItemGroup(placement: .bottomBar) {
            Button(action: {
                appState.state = ApplicationStateType.DAILY
                print("DailyView")
            }) {
                VStack {
                    Image(systemName: "bed.double.fill")
                    Text("Summary").font(.caption)
                }
                .tint(getButtonColor(button: "Daily"))
            }
            Spacer()
            Button(action: {
                appState.state = ApplicationStateType.TRENDS
                print("TrendsView")
            }) {
                VStack {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Trends").font(.caption)
                }
                .tint(getButtonColor(button: "Trends"))
            }
            Spacer()
            Button(action: {
                appState.state = ApplicationStateType.PAIRING
                print("Record Sleep")
            }) {
                VStack {
                    Image(systemName: "record.circle")
                    Text("Record").font(.caption)
                }
                .tint(getButtonColor(button: "Pairing"))
            }
            Spacer()
            Button(action: {
                appState.state = ApplicationStateType.ABOUT
                print("AboutView")
            }) {
                VStack {
                    Image(systemName: "info.circle")
                    Text("About").font(.caption)
                }
                .tint(getButtonColor(button: "About"))
            }
        }
    }
}

