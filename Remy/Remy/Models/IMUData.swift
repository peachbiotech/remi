//
//  IMUData.swift
//  Remy
//
//  Created by Jia Chun Xie on 4/11/22.
//

import Foundation

struct IMUData : Codable {
    var accelx: Float
    var accely: Float
    var accelz: Float
    var gyrox: Float
    var gyroy: Float
    var gyroz: Float
    
    init(accelx: Float, accely: Float, accelz: Float, gyrox: Float, gyroy: Float, gyroz: Float) {
        self.accelx = accelx
        self.accely = accely
        self.accelz = accelz
        self.gyrox = gyrox
        self.gyroy = gyroy
        self.gyroz = gyroz
    }
}
