//
//  Helpers.swift
//  Remy
//
//  Created by Jia Chun Xie on 4/6/22.
//

import Foundation

class Helpers {
    static func fetchDateStringFromDate(date: Date) -> String{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return String(components.year!) + String(components.month!) + String(components.day!)
    }
}
