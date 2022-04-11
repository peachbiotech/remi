//
//  ApplicationState.swift
//  Remy
//
//  Created by Jia Chun Xie on 1/26/22.
//

import Foundation

struct ApplicationState: Codable {
    var state: ApplicationStateType = ApplicationStateType.DAILY
}

enum ApplicationStateType: Int,Codable {
    case WELCOME = 0
    case VIEWCURRENT
    case DAILY
    case TRENDS
    case ABOUT
}
